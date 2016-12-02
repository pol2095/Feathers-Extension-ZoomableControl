/*
Copyright 2016 pol2095. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.extensions.utils
{
    import flash.geom.Point;

    import starling.display.DisplayObject;
    import starling.display.Sprite;
	import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
	import feathers.extensions.utils.events.TouchSheetEvent;
	
    public class TouchSheet extends Sprite
    {
		private var getPreviousLocationA:Point;
		private var getPreviousLocationB:Point;
		
		public function TouchSheet(contents:DisplayObject)
        {
            this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			if (contents)
            {
                addChild(contents);
            }
		}
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
        }
        
        private function onTouch(event:TouchEvent):void
        {
			var touchStationary:Vector.<Touch> = event.getTouches(stage, TouchPhase.STATIONARY);
			var touchMoved:Vector.<Touch> = event.getTouches(stage, TouchPhase.MOVED);
			var touches:Vector.<Touch> = touchStationary.concat(touchMoved);
			if (touches.length != 0) if( !touches[0].isTouching(this) ) return;
            
            if (touches.length == 2)
            {
                var touchA:Touch = touches[0];
                var touchB:Touch = touches[1];
                
                var currentPosA:Point  = touchA.getLocation(parent);
                var previousPosA:Point = touchA.getPreviousLocation(parent);
                var currentPosB:Point  = touchB.getLocation(parent);
                var previousPosB:Point = touchB.getPreviousLocation(parent);
				
				if(getPreviousLocationA && getPreviousLocationB)
				{
					if(getPreviousLocationA.toString() == previousPosA.toString() && getPreviousLocationB.toString() == previousPosB.toString()) return;
				}
				getPreviousLocationA = previousPosA;
				getPreviousLocationB = previousPosB;
                
                var currentVector:Point  = currentPosA.subtract(currentPosB);
                var previousVector:Point = previousPosA.subtract(previousPosB);
                
                var sizeDiff:Number = currentVector.length / previousVector.length;
                scaleX *= sizeDiff;
                scaleY *= sizeDiff;
				if(scaleX < 1) scaleX = scaleY = 1;
				dispatchEvent( new TouchSheetEvent( TouchSheetEvent.PINCHING ) );
            }
        }
        
        public override function dispose():void
        {
            stage.removeEventListener(TouchEvent.TOUCH, onTouch);
            super.dispose();
        }
    }
}