{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [ opencode ];

  xdg.configFile."opencode/opencode.jsonc".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    model = "polza/claude-sonnet-5";
    provider = {
      polza = {
        npm = "@ai-sdk/openai-compatible";
        name = "POLZA AI";
        options = {
          apiKey = "{env:POLZA_API_KEY}";
          baseURL = "https://polza.ai/api/v1";
        };
        models = {
          "claude-sonnet-5" = {
            id = "anthropic/claude-sonnet-5";
            name = "Claude Sonnet 5";
          };
          "google-gemini-3.1-pro-preview" = {
            id = "google/gemini-3.1-pro-preview";
            name = "Google: Gemini 3.1 Pro Preview";
          };
        };
      };
    };
  };
}