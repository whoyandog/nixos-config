use std::process::Command;
use std::time::Duration;

use anyhow::{Context, Result};
use clap::Parser;
use rumqttc::{AsyncClient, Event, Incoming, LastWill, MqttOptions, QoS};
use serde::{Deserialize, Serialize};
use serde_json::Value;

#[derive(Parser, Debug)]
#[command(name = "mpris-mqtt-adapter")]
#[command(about = "MPRIS/Playerctl to MQTT bridge")]
struct Cli {
    #[arg(long, default_value = "mqtt.home.arpa")]
    host: String,

    #[arg(long, default_value_t = 1883)]
    port: u16,

    #[arg(long, default_value = "workstation/media")]
    topic: String,

    #[arg(long, default_value_t = false)]
    discovery: bool,

    #[arg(long, default_value_t = 2)]
    poll_seconds: u64,

    #[arg(long, default_value = "playerctld,%any")]
    player: String,
}

#[derive(Debug, Serialize, PartialEq, Eq)]
struct PlayerState {
    state: String,
    artist: String,
    title: String,
    album: String,
    volume: String,
    position_seconds: String,
    loop_status: String,
    shuffle: String,
    player: String,
}

#[derive(Debug, Deserialize)]
struct CmdMsg {
    action: String,
    value: Option<Value>,
}

#[tokio::main]
async fn main() -> Result<()> {
    let cli = Cli::parse();

    let mut opts = MqttOptions::new("mpris-mqtt-adapter", cli.host.clone(), cli.port);
    opts.set_keep_alive(Duration::from_secs(10));

    let availability_topic = format!("{}/availability", cli.topic);
    opts.set_last_will(LastWill::new(
        availability_topic.clone(),
        "offline",
        QoS::AtLeastOnce,
        true,
    ));

    if let (Ok(username), Ok(password)) = (
        std::env::var("MQTT_USERNAME"),
        std::env::var("MQTT_PASSWORD"),
    ) {
        opts.set_credentials(username, password);
    }

    let cmd_topic = format!("{}/cmd", cli.topic);
    let state_topic = format!("{}/state", cli.topic);
    let event_topic = format!("{}/event", cli.topic);

    let (client, mut eventloop) = AsyncClient::new(opts, 50);

    client
        .publish(
            availability_topic.clone(),
            QoS::AtLeastOnce,
            true,
            "online",
        )
        .await
        .context("failed to publish availability online status")?;

    client
        .subscribe(cmd_topic.clone(), QoS::AtLeastOnce)
        .await
        .context("failed to subscribe to command topic")?;

    if cli.discovery {
        publish_discovery(&client, &cli.topic, &state_topic, &cmd_topic).await?;
    }

    let mut ticker = tokio::time::interval(Duration::from_secs(cli.poll_seconds));
    let mut last_state: Option<PlayerState> = None;

    loop {
        tokio::select! {
            _ = ticker.tick() => {
                if let Ok(state) = read_state(&cli.player) {
                    if last_state.as_ref() != Some(&state) {
                        let payload = serde_json::to_vec(&state)?;
                        client.publish(state_topic.clone(), QoS::AtLeastOnce, true, payload).await?;
                        last_state = Some(state);
                    }
                }
            }
            event = eventloop.poll() => {
                match event {
                    Ok(Event::Incoming(Incoming::Publish(publish))) => {
                        if publish.topic == cmd_topic {
                            let payload = String::from_utf8_lossy(&publish.payload).to_string();
                            if let Err(err) = handle_command(&cli.player, &payload) {
                                let msg = format!("{{\"status\":\"error\",\"message\":\"{}\"}}", sanitize(&err.to_string()));
                                let _ = client.publish(event_topic.clone(), QoS::AtLeastOnce, false, msg).await;
                            }
                        }
                    }
                    Ok(_) => {}
                    Err(err) => {
                        let msg = format!("{{\"status\":\"mqtt-error\",\"message\":\"{}\"}}", sanitize(&err.to_string()));
                        let _ = client.publish(event_topic.clone(), QoS::AtLeastOnce, false, msg).await;
                        tokio::time::sleep(Duration::from_secs(2)).await;
                    }
                }
            }
        }
    }
}

fn sanitize(s: &str) -> String {
    s.replace('"', "'")
}

async fn publish_discovery(client: &AsyncClient, base_topic: &str, state_topic: &str, cmd_topic: &str) -> Result<()> {
    let availability_topic = format!("{}/availability", base_topic);
    let device = serde_json::json!({
        "identifiers": ["workstation_media"],
        "name": "Workstation Media Adapter",
        "manufacturer": "custom",
        "model": "mpris-mqtt-adapter"
    });

    let discovery_entries: [(&str, serde_json::Value); 8] = [
        (
            "homeassistant/sensor/workstation_media_state/config",
            serde_json::json!({
                "name": "Workstation Media State",
                "unique_id": "workstation_media_state",
                "state_topic": state_topic,
                "value_template": "{{ value_json.state }}",
                "availability_topic": availability_topic,
                "payload_available": "online",
                "payload_not_available": "offline",
                "device": device
            }),
        ),
        (
            "homeassistant/sensor/workstation_media_title/config",
            serde_json::json!({
                "name": "Workstation Media Title",
                "unique_id": "workstation_media_title",
                "state_topic": state_topic,
                "value_template": "{{ value_json.title }}",
                "availability_topic": availability_topic,
                "payload_available": "online",
                "payload_not_available": "offline",
                "device": device
            }),
        ),
        (
            "homeassistant/sensor/workstation_media_artist/config",
            serde_json::json!({
                "name": "Workstation Media Artist",
                "unique_id": "workstation_media_artist",
                "state_topic": state_topic,
                "value_template": "{{ value_json.artist }}",
                "availability_topic": availability_topic,
                "payload_available": "online",
                "payload_not_available": "offline",
                "device": device
            }),
        ),
        (
            "homeassistant/sensor/workstation_media_album/config",
            serde_json::json!({
                "name": "Workstation Media Album",
                "unique_id": "workstation_media_album",
                "state_topic": state_topic,
                "value_template": "{{ value_json.album }}",
                "availability_topic": availability_topic,
                "payload_available": "online",
                "payload_not_available": "offline",
                "device": device
            }),
        ),
        (
            "homeassistant/button/workstation_media_play_pause/config",
            serde_json::json!({
                "name": "Workstation Media Play Pause",
                "unique_id": "workstation_media_play_pause",
                "command_topic": cmd_topic,
                "payload_press": "{\"action\":\"play_pause\"}",
                "availability_topic": availability_topic,
                "payload_available": "online",
                "payload_not_available": "offline",
                "device": device
            }),
        ),
        (
            "homeassistant/button/workstation_media_next/config",
            serde_json::json!({
                "name": "Workstation Media Next",
                "unique_id": "workstation_media_next",
                "command_topic": cmd_topic,
                "payload_press": "{\"action\":\"next\"}",
                "availability_topic": availability_topic,
                "payload_available": "online",
                "payload_not_available": "offline",
                "device": device
            }),
        ),
        (
            "homeassistant/button/workstation_media_previous/config",
            serde_json::json!({
                "name": "Workstation Media Previous",
                "unique_id": "workstation_media_previous",
                "command_topic": cmd_topic,
                "payload_press": "{\"action\":\"previous\"}",
                "availability_topic": availability_topic,
                "payload_available": "online",
                "payload_not_available": "offline",
                "device": device
            }),
        ),
        (
            "homeassistant/button/workstation_media_stop/config",
            serde_json::json!({
                "name": "Workstation Media Stop",
                "unique_id": "workstation_media_stop",
                "command_topic": cmd_topic,
                "payload_press": "{\"action\":\"stop\"}",
                "availability_topic": availability_topic,
                "payload_available": "online",
                "payload_not_available": "offline",
                "device": device
            }),
        ),
    ];

    for (topic, payload) in discovery_entries {
        client
            .publish(topic, QoS::AtLeastOnce, true, serde_json::to_vec(&payload)?)
            .await?;
    }

    client.publish(format!("{}/availability", base_topic), QoS::AtLeastOnce, true, "online").await?;
    Ok(())
}

fn handle_command(player: &str, payload: &str) -> Result<()> {
    let cmd = parse_command(payload);
    match cmd.action.as_str() {
        "play" => run_playerctl(player, &["play"]),
        "pause" => run_playerctl(player, &["pause"]),
        "play_pause" | "toggle" => run_playerctl(player, &["play-pause"]),
        "next" => run_playerctl(player, &["next"]),
        "prev" | "previous" => run_playerctl(player, &["previous"]),
        "stop" => run_playerctl(player, &["stop"]),
        "volume_set" => {
            if let Some(value) = cmd.value.and_then(|v| v.as_f64()) {
                run_playerctl(player, &["volume", &value.to_string()])
            } else {
                anyhow::bail!("volume_set requires numeric value")
            }
        }
        "volume_up" => {
            if let Some(value) = cmd.value.and_then(|v| v.as_f64()) {
                run_playerctl(player, &["volume", &format!("+{}", value)])
            } else {
                run_playerctl(player, &["volume", "+0.05"])
            }
        }
        "volume_down" => {
            if let Some(value) = cmd.value.and_then(|v| v.as_f64()) {
                run_playerctl(player, &["volume", &format!("-{}", value)])
            } else {
                run_playerctl(player, &["volume", "-0.05"])
            }
        }
        "mute" => run_playerctl(player, &["volume", "0"]),
        "position_set" => {
            if let Some(value) = cmd.value.and_then(|v| v.as_f64()) {
                run_playerctl(player, &["position", &value.to_string()])
            } else {
                anyhow::bail!("position_set requires numeric value in seconds")
            }
        }
        "position_seek" => {
            if let Some(value) = cmd.value.and_then(|v| v.as_f64()) {
                if value >= 0.0 {
                    run_playerctl(player, &["position", &format!("+{}", value)])
                } else {
                    run_playerctl(player, &["position", &value.to_string()])
                }
            } else {
                anyhow::bail!("position_seek requires numeric value in seconds")
            }
        }
        "loop_none" => run_playerctl(player, &["loop", "None"]),
        "loop_track" => run_playerctl(player, &["loop", "Track"]),
        "loop_playlist" => run_playerctl(player, &["loop", "Playlist"]),
        "shuffle_on" => run_playerctl(player, &["shuffle", "On"]),
        "shuffle_off" => run_playerctl(player, &["shuffle", "Off"]),
        _ => anyhow::bail!("unknown action: {}", cmd.action),
    }
}

fn parse_command(payload: &str) -> CmdMsg {
    if let Ok(json) = serde_json::from_str::<CmdMsg>(payload) {
        return json;
    }

    CmdMsg {
        action: payload.trim().to_string(),
        value: None,
    }
}

fn read_state(player: &str) -> Result<PlayerState> {
    let format = "{{status}}\t{{artist}}\t{{title}}\t{{album}}\t{{volume}}\t{{position}}\t{{loop}}\t{{shuffle}}\t{{playerName}}";
    let output = Command::new("playerctl")
        .arg("--player")
        .arg(player)
        .arg("metadata")
        .arg("--format")
        .arg(format)
        .output()
        .context("failed to execute playerctl metadata")?;

    if !output.status.success() {
        anyhow::bail!("playerctl returned non-zero exit status")
    }

    let line = String::from_utf8_lossy(&output.stdout).trim().to_string();
    let mut parts = line.split('\t');
    let state = parts.next().unwrap_or("Stopped").to_string();
    let artist = parts.next().unwrap_or("").to_string();
    let title = parts.next().unwrap_or("").to_string();
    let album = parts.next().unwrap_or("").to_string();
    let volume = parts.next().unwrap_or("").to_string();
    let position_seconds = parts.next().unwrap_or("").to_string();
    let loop_status = parts.next().unwrap_or("").to_string();
    let shuffle = parts.next().unwrap_or("").to_string();
    let player_name = parts.next().unwrap_or("").to_string();

    Ok(PlayerState {
        state,
        artist,
        title,
        album,
        volume,
        position_seconds,
        loop_status,
        shuffle,
        player: player_name,
    })
}

fn run_playerctl(player: &str, args: &[&str]) -> Result<()> {
    let status = Command::new("playerctl")
        .arg("--player")
        .arg(player)
        .args(args)
        .status()
        .context("failed to execute playerctl")?;

    if status.success() {
        Ok(())
    } else {
        anyhow::bail!("playerctl command failed")
    }
}

