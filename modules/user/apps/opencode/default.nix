{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [ opencode ];

  xdg.configFile."opencode/opencode.jsonc".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    model = "polza/google/gemini-3.8-flash"; 
    provider = {
      polza = {
        npm = "@ai-sdk/openai-compatible";
        name = "POLZA AI";
        options = {
          baseURL = "https://polza.ai/api/v1";
          apiKey = "{env:POLZA_API_KEY}"; 
        };
        models = {
          "google/gemini-3.8-flash" = { name = "Gemini 3.8 Flash"; };
          "google/gemini-3.1-pro-preview" = { name = "Gemini 3.1 Pro Preview"; };
          "claude-sonnet-5" = { name = "Claude Sonnet 5"; };
        };
      };
    };
  };
}