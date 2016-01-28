package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Camera;
	import flash.media.Microphone;
    import flash.media.Video;
	import flash.net.NetConnection;
    import flash.net.NetStream;
	import flash.events.*;
	import flash.media.H264Level;
	import flash.media.H264Profile;
	import flash.media.H264VideoStreamSettings;
	
	/**
	 * ...
	 * @author max
	 */
	public class Main extends Sprite 
	{
		private var camera:Camera;
        private var video:Video;
		private var nc:NetConnection;
		private var mic:Microphone;
		private var ns_out:NetStream;
		private var ns_in:NetStream;
		private var vid_out:Video;
		
		public function Main() 
		{
			if (stage) init();
		}
		
		private function init(e:Event = null):void 
		{
			
			initConnection();
			trace("Mes couilles");
			mic = Microphone.getMicrophone();
			mic.gain = 100;
			camera = Camera.getCamera(); 
			camera.setMode(640, 480, 30, true);
			camera.setKeyFrameInterval(15);
			camera.setQuality( 90000, 90 );
            video =  new Video(640, 480);
			mic.setLoopBack(true);
            video.attachCamera(camera);
            addChild(video);
			
		}
		
		private function initConnection():void
		{
			nc = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			nc.connect("rtmp://127.0.0.1/live");
			trace("Mes couilles 2");
		}
		
		protected function onNetStatus(event:NetStatusEvent):void
		{
			trace(event.info.code);
			if(event.info.code =="NetConnection.Connect.Success")
			{ 
				publishCamera(); 
				//displayPublishingVideo(); 
				//displayPlaybackVideo();
			}
		}
		
		protected function publishCamera():void
		{ 
			ns_out = new NetStream( nc );
			ns_out.attachCamera( camera );
			var h264Settings:H264VideoStreamSettings = new H264VideoStreamSettings();
			h264Settings.setProfileLevel( H264Profile.BASELINE,  H264Level.LEVEL_3_1 );
			ns_out.videoStreamSettings = h264Settings;
			ns_out.publish( "mp4:webCam.f4v", "live" );
		}
		
	}
}