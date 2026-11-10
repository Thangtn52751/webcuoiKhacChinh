/// AssetSource paths omit the leading assets/ directory.
String weddingMusicAssetForWidth(double viewportWidth) =>
    viewportWidth <= 720 ? 'audio/music.mobile.mp3' : 'audio/music.mp3';
