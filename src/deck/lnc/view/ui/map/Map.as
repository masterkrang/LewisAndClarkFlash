package deck.lnc.view.ui.map
{
	//import assets.Building11;
	
	import com.greensock.TweenMax;
	import com.kurt.util.LayoutFactory;
	
	import deck.lnc.model.vo.map.LocationVO;
	import deck.lnc.model.vo.map.MapVO;
	import deck.lnc.model.vo.map.SectionVO;
	
	import fl.containers.ScrollPane;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.net.URLRequest;
	import flash.sampler.getInvocationCount;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	
	public class Map extends Sprite
	{
		
		//map
		private var mapLoader:Loader;
		private var mapPath:String = "";
		private var markers:Vector.<Marker>;
		
		private var s:ScrollPane = new ScrollPane();
		
		//vector map
		private var map:Sprite;
		
		private var selected:uint;
		
		public var mapVO:MapVO;
		
		public static const MAP_LOAD_COMPLETE:String = "mapLoaded";
		//public static const MARKER_CLICK:String = "markerClick";
		public static const LOCATION_CLICK:String = "locationClick";
		
		public var originalHeight:Number;
		public var originalWidth:Number;
		
		//drop shadow for markers
		private var dropShadow:DropShadowFilter;
		
		private var scrim:Sprite;
		
		//array of regions
		private var regions:Vector.<Region>;
		public var locations:Vector.<Location>;
		
		//panel that's pops up on rollover of regions, or on highlight of region
		private var locationMetadata:LocationMetadata;
		
		private var currentMapZoomPercent:Number;
		
		//private var building1:Building1;
		
		//building sprites
		//private var building3:Sprite;
		//private var building26:Sprite;
		
		public var locationOverIndex:uint = 0; //may need to take this off of 0
	
		public function Map()
		{
			init();
		}
		
		public function init():void {
			//this function is going to look weird and needs explanation
			letTheCompilerKnowAboutSWCAssets();
		
			markers = new Vector.<Marker>();
			
			dropShadow = new DropShadowFilter(4, 270, 0, .5);
			
			scrim = new Sprite();
		
			regions = new Vector.<Region>();
			
			locations = new Vector.<Location>();
			
			locationMetadata = new LocationMetadata();
			//too intense
			//map = new MapVector();
			
			//map = new MapImage();
			
			//set original width / height
			originalWidth = 1614;
			originalHeight = 1270;
			
			//buildingds
			//building3 = new Building3();
			//building26 = new Building26();
			
			draw();
		}
		
		private function draw():void {
			addChild(new OtherMapSections());
			//addChild(map);
			
			//addChild(
			//dispatch map loaded 
			//dispatchEvent(new Event(MAP_LOADED));
			//hack, needs to change
			//addChild(s);
			//s.source = new MapImage();
		}
		
		private function letTheCompilerKnowAboutSWCAssets():void {
			Building1;
			Building2;
			Building3;
			Building4;
			Building5;
			Building10;
			Building11;
			Building12;
			Building14;
			Building15;
			Building17;
			//Building18;
			Building20;
			Building21;
			Building22;
			Building23;
			Building24;
			Building25;
			Building26;
			Building27;
			Building28;
			Building29;
			Building30;
			Building31;
			Building32;
			Building33;
			Building34;
			Building35;
			Building36;
			Building40;
			Building41;
			Building42;
			Building43;
			Building44;
			Building45;
			Building46;
			Building47;
			Building49;
			Building50;
			Building81;
			Building81A;
			Building81B;
			Building82;
			Building83;
			Building84;
			Building85;
			
			BuildingL1;
			BuildingL2A;
			BuildingL2B;
			BuildingL3;
			BuildingL4;
		}
		
		public function set dataProvider(_mapVO:MapVO):void {
			//trace("Map::dataProvider");
			mapVO = _mapVO;
			
			//loadMap();
			
			
			
			//setMarkers();
			//placeMarkers();
			
			setLocations();
		}
		
		public function setCurrentMapZoomePercent(_percent:Number):void {
			currentMapZoomPercent = _percent;
		}
		
		public function getCurrentMapZoomPercent():Number {
			return currentMapZoomPercent;
		}
		
		/****************** LOCATIONS ********************/
	
		public function setLocations():void {
			/*
			var locationsLength:Number = xml.locations.location.length();
			for (var i:uint = 0; i < locationsLength; i++) {
				var location:Location = getLocation(xml.locations.location[i]);
				location.setIndex(i);
				locations.push(location);
				addChild(location);
			}
			*/
			var sectionsLength:uint = mapVO.sections.length;
			var k:uint = 0; //to aggregate locations
			for (var i:uint = 0; i < sectionsLength; i++) {
				var section:SectionVO = mapVO.sections[i];
				var locationsLength:Number = section.locations.length;
				//trace("section.locations.length " + section.locations.length);
				for (var j:uint = 0; j < locationsLength; j++) {
					var location:Location = getLocation(section.locations[j]);
					
					location.setIndex(k);
					//location
					
					location.addEventListener(Location.OUT_ANIMATION_COMPLETE, outAnimationComplete);
					
					locations.push(location);
					
					addChild(location);
					
					k++;
				}
			}
			
			//trace("ORIGINAL WIDTH " + this.width + " ORIGINAL HEIGHT " + this.height);
			//trace("this scaleX " + this.scaleX + " this scaleY " + this.scaleY);
			
			originalHeight = this.height;
			originalWidth = this.width;
			
			//need to dispatch an even saying map is ready so we can get the right size of the mop
			dispatchEvent(new Event(MAP_LOAD_COMPLETE));
			
		}
		
		private function outAnimationComplete(e:Event):void {
			//check if anybody is over
			//if nobody is over then we should take off all the blur filters
			var llen:uint = locations.length;
			var active:Boolean;
			for (var i:uint = 0; i < llen; i++) {
				if (locations[i].isOvered()) {
					active = true;
				}
			}
			
			if(active) {
			
			} else {
				for (i = 0; i < llen; i++) {
					locations[i].filters = []
				}
			}
			
		}
		
		private function getLocation(lvo:LocationVO):Location {
			
			var l:Location = new Location();
			
			l.dataProvider = lvo;
			
			l.xPosition = lvo.xPosition;
			l.yPosition = lvo.yPosition;
			
			l.x = l.xPosition;
			l.y = l.yPosition;
			//l.title = _xml.title;
			//l.description = _xml.description;
			
			l.dashboardPath = lvo.dashboardPath;
			
			l.addEventListener(MouseEvent.CLICK, locationClick);
			l.addEventListener(MouseEvent.MOUSE_OVER, locationOver);
			l.addEventListener(MouseEvent.MOUSE_OUT, locationOut);
			
			//m.mouseChildren = false;
			//m.buttonMode = true;
			//m.useHandCursor = true;
			//add a drop shadow
			//l.filters = [dropShadow];
			var bn:String = lvo.buildingNumber;
			var className:String = "Building" + bn;
			//trace("class name " + className);
			try {
				//l.setLocationGraphic(this[f]());
				if(ApplicationDomain.currentDomain.hasDefinition(className)) {
					var _Class:Class = getDefinitionByName(className) as Class;
					l.setLocationGraphic(new _Class());
				} else {
					trace("class does not exist " + className);
				}
				
			} catch (e:Error) {
				trace("error calling builder function");
			}
			
			//now we can set the original height and width of this object so we know how to scale it later
			//trace("location width " + l.width + " location height " + l.height);
			l.originalWidth = l.width;
			l.originalHeight = l.height;
			
			return l;
		}
		
		/************** LOCATION EVENTS *****************/
		
		
		public function locationClick(me:MouseEvent):void {
			trace("location click");
			
		//lock the map, maybe lock the app
			var clickedLocation:Location = Location(me.target);
			//do map specific click stuff like selections
			
			//var scaleFactor:Number = getLocationScaleFactor(clickedLocation);
			//trace("this.width " + this.width + " this.height " + this.height);
			//TweenMax.to(clickedLocation, .5, {scaleX:scaleFactor, scaleY:scaleFactor, x:originalWidth / 2, y:originalHeight / 2});
			
			setSelected(Location(me.target).getIndex());
			
			dispatchEvent(new Event(LOCATION_CLICK));
		}
		
		
		
		private function locationOver(me:MouseEvent):void {
			//trace("location over");
			var lastOverIndex:uint = locationOverIndex;
			
			//turn off last over index? or let mouse out take care of it
			
			
			//trace("me.target location over " + me.target);
			locationOverIndex = Location(me.currentTarget).getIndex();
			var location:Location = locations[locationOverIndex];
			
			//add the child again for stacking
			addChild(location);
			
			location.over();
			location.filters = [];
			
			//set a blur to everybody who wasn't rolled over
			var llen:uint = locations.length;
			for (var i:uint = 0; i < llen; i++) {
				if(i != locationOverIndex) {
					locations[i].filters = [new BlurFilter()];
				}
			}
		}
		
		private function locationOut(me:MouseEvent):void {
			//trace("location out");
			
			var location:Location = locations[Location(me.currentTarget).getIndex()];
			location.out();
		}
		
		//maybe these should be a sort of subordinate highlight?
		public  function simulateLocationOver(overedIndex:uint):void {
			locations[overedIndex].dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
		}
		
		public function simulateLocationOut(outedIndex:uint):void {
			locations[outedIndex].dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
		}
		
		public function simulateLocationClick(clickedIndex:uint):void {
			locations[clickedIndex].dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		/***************************************************/
		
		
		private function setSelected(_selected:uint):void {
			selected = _selected;
		}
		
		public function getSelected():uint {
			return selected;
		}
		
		public function getSelectedLocation():Location {
			return locations[getSelected()];
		}
		
		public function enable():void {
			mouseChildren = true;
		}
		
		public function disable():void {
			mouseChildren = false;
			//make sure everybody is in rolled out state
			
			var llen:uint = locations.length;
			for (var i:uint = 0; i < llen; i++) {
				//turn off filters if any
				locations[i].filters = [];
				//roll em all out state
				locations[i].out();
			}
		}
		
		/***************************************************/
		
		
		
		private function loadMap():void {
			mapLoader = new Loader();
			mapLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, mapLoaderProgress);
			mapLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, mapLoaded);
			//mapLoader.load(new URLRequest(xml.mapurl));
		}
		
		private function mapLoaderProgress(pe:ProgressEvent):void {
			//trace("map loader progress");
		}
		
		private function mapLoaded(e:Event):void {
			
			//important to turn on smoothing for smooth scalling
			var bitmap:Bitmap = Bitmap(mapLoader.content);
			bitmap.smoothing = true;
			
			//make it fit into the screen
			
			//add it
			addChild(mapLoader);
			
			//add the markers to the top of the map
			
			//placeMarkers();
			
			
			//stack twitter widget on top of map
			//addChild(twitterWidget);
			
			//dispatch map loaded 
			//dispatchEvent(new Event(MAP_LOADED));
			//snapFit(mapLoader);
			
		}
		
	}
}