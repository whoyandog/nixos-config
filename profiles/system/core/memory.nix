{ ... }: {
    zramSwap = {
        enable = true;
        algorithm = "zstd";
        memoryPercent = 50;
    };

    services.earlyoom = {
        enable = true;
        freeMemThreshold = 5;
        freeSwapThreshold = 10;
        enableNotifications = true;
    };
}