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
	import flash.display.Sprite; 
    import flash.text.*; 
	
	/**
	 * ...
	 * @author max
	 */
	public class Main extends Sprite 
	{
		private var video:Video;
		private var ns_in:NetStream;
		private var nc:NetConnection;
		private var myTextBox:TextField = new TextField(); 
		private var myText:String = "Initial";
		
		public function Main() 
		{
			if (stage) init();
		}
		
		private function init(e:Event = null):void 
		{
			myTextBox.text = myText;
			myTextBox.width = 200; 
            myTextBox.height = 200; 
            myTextBox.multiline = true; 
            myTextBox.wordWrap = true; 
            myTextBox.border = true; 
			video =  new Video(640, 480);
			nc = new NetConnection();
			nc.connect("rtmp://127.0.0.1/live");
			nc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			addChild(myTextBox);
			
		}
		
		protected function onNetStatus(event:NetStatusEvent):void
		{
			trace(event.info.code);
			if(event.info.code =="NetConnection.Connect.Success")
			{ 
				myTextBox.text = "Success";
				ns_in = new NetStream( nc );
				ns_in.client = this;
				ns_in.play( "mp4:webCam.f4v" );
				video.attachNetStream( ns_in );
				addChild(video);
			}
			else
			{
				myTextBox.text = "Failed";
			}
			
		}
		
	}
	
}