package deck.lnc.view.ui.listpanel
{
	import com.greensock.TweenMax;
	
	import deck.lnc.model.vo.map.LocationVO;
	import deck.lnc.model.vo.map.MapVO;
	import deck.lnc.model.vo.map.SectionVO;
	import deck.lnc.view.ui.scroller.Scroller;
	
	import fl.containers.ScrollPane;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ListPanel extends Sprite
	{
		private var selectedIndex:uint;
		private var overedIndex:uint;
		private var outedIndex:uint;
		
		private var listItems:Vector.<ListItem>;
		private var locations:Vector.<String>; //for ajaxy goodness
		
		//constants
		public static const SCROLLBAR_WIDTH:Number = 15; //need to keep track of the proper margin to get rid of horiz scroll
		
		//private var scroller:Scroller;
		private var scroller:ScrollPane;
		
		//list item container
		private var listItemContainer:MovieClip;
		
		//data
		private var mapVO:MapVO;
		
		//events
		public static const MOUSE_OVER:String = "listPanelItemOver";
		public static const MOUSE_OUT:String = "listPanelItemOut";
		public static const MOUSE_CLICK:String = "listPanelItemClick";
		
		public function ListPanel()
		{
			super();
			init();
		}
		
		private function init():void {
			
			listItems = new Vector.<ListItem>();
			locations = new Vector.<String>();
			
			scroller = new ScrollPane(); //new Scroller();//;new ScrollPane();
			
			
			listItemContainer = new MovieClip();
			
			draw();
		}
		
		private function draw():void {
			
			/*
			var s:Sprite = new Sprite();
			s.graphics.beginFill(0xFF0000);
			s.graphics.drawRect(0,0,20,20);
			s.graphics.endFill();
			addChild(s);
			*/
		}
		
		public function set dataProvider(_mapVO:MapVO):void {
			
			//trace("ListPanel dataprovider");
			mapVO = _mapVO;
			
			
			//iterate through sections
			var sectionsLength:uint = mapVO.sections.length;
			//trace("ListPanel section length " + sectionsLength);
			var j:uint = 0; //aggregate for locations
			for(var i:uint = 0; i < sectionsLength; i++) {
				//create list items
				var section:SectionVO = mapVO.sections[i];
				var ilen:uint = section.locations.length;
				for (; j < ilen; j++) {
					
					var li:ListItem = getListItem(section.locations[j]);
					
					listItemContainer.addChild(li);
					
					li.y = j * ListItem.HEIGHT;
					
					li.index = j;
					
					//addChild(li);
					
					li.addEventListener(ListItem.CLICK, onListItemClick);
					li.addEventListener(ListItem.OVER, onListItemOver);
					li.addEventListener(ListItem.OUT, onListItemOut);
					
					listItems.push(li);
				}
			}
			
			
			
			//scroller.source = listItemContainer;
			
			//addChild(listItemContainer);
			scroller.alpha = 0;
			scroller.x = 1;
			scroller.y = 1;
			addChild(scroller);
			
			
			//wait for a second before adding the listItem
			TweenMax.delayedCall(.5, addScrollPaneContent);
		}
		
		private function onListItemOver(e:Event):void {
			//trace("ListPanel onListItemOver");
			setOverIndex(ListItem(e.target).index);
			
			dispatchEvent(new Event(MOUSE_OVER));
		}
		
		private function onListItemOut(e:Event):void {
			//trace("ListPanel onListItemOut");
			setOutIndex(ListItem(e.target).index);
			
			dispatchEvent(new Event(MOUSE_OUT));
		}
		
		private function onListItemClick(e:Event):void {
			//trace("ListPanel listItemClicked " + ListItem(e.target).index);
			
			var clicked:uint = ListItem(e.target).index;
			
			//deselect 
			var llen:uint = listItems.length;
			
			for (var i:uint = 0; i < llen; i++) {
				
				if(i != clicked) {
					listItems[i].deselect();
				}
			}
			
			setSelectedIndex(clicked);
			
			dispatchEvent(new Event(MOUSE_CLICK));
		}
		
		public function getSelectedIndex():uint {
			return selectedIndex;
		}
		
		public function setSelectedIndex(_selectedIndex:uint):void {
			selectedIndex = _selectedIndex;
		}
		
		public function setOverIndex(_overIndex:uint):void {
			overedIndex = _overIndex;
		}
		
		public function getOverIndex():uint {
			return overedIndex;
		}
		
		public function getOutIndex():uint {
			return outedIndex;
		}
		
		
		public function setOutIndex(_outedIndex:uint):void {
			outedIndex = _outedIndex;
		}
		
		private function addScrollPaneContent():void {
			
			//cleverly tween these guys in
			scroller.source = listItemContainer;
			//listItemContainer.mouseChildren = false;
			scroller.width = ListItem.WIDTH + SCROLLBAR_WIDTH;
			//scroller.height = 500;
			//scroller.maxVerticalScrollPosition = listItemContainer.height;
			scroller.update();
			
			TweenMax.to(scroller, 1, {alpha:1});
		}
		
		public function setHeight(h:Number):void {
			scroller.height = h;
		}
		
		public function setWidth(w:Number):void {
			scroller.width = w;
		}
		
		private function onScrollPaneComplete(e:Event):void {
			trace("scrollpane complete");
			//scroller.update();
		}
		
		private function getListItem(_location:LocationVO):ListItem {
			var li:ListItem = new ListItem();
			
			li.dataProvider = _location;
			
			return li;
		}
	}
}