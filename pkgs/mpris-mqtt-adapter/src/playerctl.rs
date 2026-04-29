use std::process::Command;

use anyhow::{Context, Result};

use crate::types::PlayerState;
use crate::util::{parse_f64, parse_mpris_length, parse_mpris_position, sanitize};

fn run_playerctl_output(player: &str, args: &[&str]) -> Result<String> {
    let output = Command::new("playerctl")
        .arg("--player")
        .arg(player)
        .args(args)
        .output()
        .with_context(|| format!("failed to run playerctl {:?}", args))?;

    if !output.status.success() {
        let stderr = String::from_utf8_lossy(&output.stderr);
        anyhow::bail!("playerctl {:?} failed: {}", args, stderr.trim());
    }

    Ok(String::from_utf8_lossy(&output.stdout).trim().to_string())
}

pub fn run_playerctl(player: &str, args: &[&str]) -> Result<()> {
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

pub fn read_state(player: &str) -> Result<PlayerState> {
    let template = "{{status}}\t{{artist}}\t{{title}}\t{{album}}\t{{mpris:artUrl}}\t{{volume}}\t{{position}}\t{{mpris:length}}\t{{loop}}\t{{shuffle}}\t{{playerName}}";

    let out = run_playerctl_output(player, &["metadata", "--format", template])?;
    let parts: Vec<&str> = out.split('\t').collect();
    if parts.len() < 11 {
        anyhow::bail!("metadata output has unexpected format");
    }

    let state = parts[0].trim().to_lowercase();
    let artist = sanitize(parts[1].trim());
    let title = sanitize(parts[2].trim());
    let album = sanitize(parts[3].trim());
    let art_url = sanitize(parts[4].trim());

    let volume = parse_f64(parts[5]);
    let position_seconds = parse_mpris_position(parts[6]);
    let duration_seconds = parse_mpris_length(parts[7]);

    let loop_status = parts[8].trim().to_lowercase();
    let shuffle = parts[9].trim().to_lowercase();
    let player_name = sanitize(parts[10].trim());

    Ok(PlayerState {
        state,
        artist,
        title,
        album,
        art_url,
        volume,
        position_seconds,
        duration_seconds,
        loop_status,
        shuffle,
        player: player_name,
    })
}
