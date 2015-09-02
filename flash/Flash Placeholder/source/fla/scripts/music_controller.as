
// music fader
function superMusicFader(musicInstanceName, targetVolume, fadeSpeed) {
	if(targetVolume == 0){
		TweenLite.to(musicInstanceName, fadeSpeed, {volume:targetVolume, onComplete:musicPause, onCompleteParams:[musicInstanceName]});
	} else {
		if(_root.musicPaused == true){
			_root.musicPaused = false;
			musicInstanceName.start(_root.musicResumePoint);
		}
		TweenLite.to(musicInstanceName, fadeSpeed, {volume:targetVolume});
	}	
	//TweenLite.to(musicInstanceName, fadeSpeed, {volume:targetVolume});
}
_root.superMusicFader = superMusicFader;

function externalMp3() {
	_root.music = new Sound();
	_root.music.loadSound(_root.musicPath, true);
	_root.currentVolume = _root.music.getVolume();
	_root.music.onSoundComplete = function() {
		//function to listen for music to end
		//then loop 990 times
		_root.music.start(0, 999);
	};
}
function swfMusic() {
	createEmptyMovieClip(musicHolder, getNextHighestDepth());
	musicHolder.loadMovie(_root.musicPath);
}
function musicPause(musicInstanceName){
	_root.musicPaused = true;
	_root.musicResumePoint = musicInstanceName.position / 1000; 
	_root.musicInstanceName.stop();
}

function initMusic(){
	//trace("[] [] music enabled = "+_root.flashConfig_xml.music[0].enabled)
	if (flashConfig_xml.music[0].enabled == true || _root.musicEnabled == true) {
		if(!_root.musicPath){
			_root.musicPath = _root.flashConfig_xml.music[0].track[0].src;
		} 
		fileType = _root.musicPath.substring(_root.musicPath.length-3, _root.musicPath.length);
		if (fileType == "mp3" || fileType == "MP3") {
			externalMp3();
		} else if (fileType == "swf" || fileType == "SWF") {
			swfMusic();
		} else {
			_root.superMusicFader(_root.music, 0, .1);
		}
		
	}
}
