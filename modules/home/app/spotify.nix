{
  inputs,
  pkgs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in {
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  home.packages = [
    pkgs.spotifast
    # inputs.spotifast.packages."${pkgs.stdenv.hostPlatform.system}".default
  ];

  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      fullAlbumDate
    ];
  };

  xdg.configFile."spotify-flags.conf".text = ''
    --ozone-platform=wayland
    --enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer
  '';

  programs.spotify-player = {
    enable = false;
    settings = {
      login_redirect_uri = "http://127.0.0.1:8989/login";
      client_port = 8080;
      client_id = "84581fe7f9d443e1a1ba7dc83238f263";
      tracks_playback_limit = 50;
      playback_format = "{status} {track} • {artists}\n{album} • {genres}\n{metadata}";
      playback_metadata_fields = [
        "repeat"
        "shuffle"
        "volume"
        "device"
      ];
      notify_format = {
        summary = "{track} • {artists}";
        body = "{album}";
      };
      notify_timeout_in_secs = 0;
      app_refresh_duration_in_ms = 32;
      playback_refresh_duration_in_ms = 0;
      page_size_in_rows = 20;
      enable_media_control = false;
      enable_streaming = "Always";
      enable_notify = true;
      enable_cover_image_cache = true;
      notify_streaming_only = false;
      default_device = "iusenixbtw";
      play_icon = "▶";
      pause_icon = "▌▌";
      liked_icon = "♥";
      genre_num = 2;
      cover_img_length = 9;
      cover_img_width = 5;
      cover_img_pixels = 16;
      seek_duration_secs = 5;

      device = {
        name = "iusenixbtw";
        device_type = "speaker";
        volume = 70;
        bitrate = 320;
        audio_cache = false;
        normalization = false;
        autoplay = true;
      };

      layout = {
        library = {
          playlist_percent = 40;
          album_percent = 40;
        };
        playback_window_position = "Top";
        playback_window_height = 6;
      };
    };
  };
}
