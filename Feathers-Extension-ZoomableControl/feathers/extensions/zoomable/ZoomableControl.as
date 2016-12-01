/*
Copyright 2016 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.extensions.zoomable
{
	import feathers.core.FeathersControl;
	import feathers.controls.ScrollContainer;
	
    import feathers.extensions.utils.TouchSheet;
	
	import feathers.extensions.utils.events.TouchSheetEvent;
	import starling.display.DisplayObject;
	
    /**
	 * A control that allows you to pinch to zoom.
	 */
	public class ZoomableControl extends FeathersControl
    {
		private var sheet:TouchSheet;
		/**
		 * The ScrollContainer of this control.
		 */
		public var scroller:ScrollContainer;
		
		public function ZoomableControl()
        {
            //
        }
		
		/**
		 * The ZoomableControl display object that is pinch to zoom.
		 */
		public function set renderer(displayObject:DisplayObject):void
        {
			if(sheet)
			{
				sheet.dispose();
				sheet.removeChildren();
				this.removeChild(sheet);
				sheet.removeEventListener(TouchSheetEvent.PINCHING, onPinching);
			}
			
			sheet = new TouchSheet( displayObject, stage );
			sheet.addEventListener(TouchSheetEvent.PINCHING, onPinching);
            this.addChild(sheet);
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}
		
		private function onPinching(event:TouchSheetEvent):void
        {
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
			if(scroller) scroller.stopScrolling();
		}
		/**
		 * @private
		 */
		override protected function draw():void
        {
			this.autoSizeIfNeeded();
        }
		/**
		 * @private
		 */
        protected function autoSizeIfNeeded():Boolean
        {
            var needsWidth:Boolean = isNaN(this.explicitWidth);
            var needsHeight:Boolean = isNaN(this.explicitHeight);
            if(!needsWidth && !needsHeight)
            {
                return false;
            }
			
            var newWidth:Number = this.explicitWidth;
            if(needsWidth)
            {
                newWidth = sheet ? sheet.x + sheet.width : 0;
            }
            var newHeight:Number = this.explicitHeight;
            if(needsHeight)
            {
                newHeight = sheet ? sheet.y + sheet.height : 0;
            }
 
            return this.setSizeInternal(newWidth, newHeight, false);
        }
	}
}