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
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
	import feathers.extensions.utils.events.TouchSheetEvent;
	
    public class TouchSheet extends Sprite
    {
		public function TouchSheet(contents:DisplayObject, stage:Object)
        {
            addEventListener(TouchEvent.TOUCH, onTouch);
            
            if (contents)
            {
                addChild(contents);
            }
        }
        
        private function onTouch(event:TouchEvent):void
        {
			var touches:Vector.<Touch> = event.getTouches(stage, TouchPhase.MOVED);
            
            if (touches.length == 2)
            {
                var touchA:Touch = touches[0];
                var touchB:Touch = touches[1];
                
                var currentPosA:Point  = touchA.getLocation(parent);
                var previousPosA:Point = touchA.getPreviousLocation(parent);
                var currentPosB:Point  = touchB.getLocation(parent);
                var previousPosB:Point = touchB.getPreviousLocation(parent);
                
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
            removeEventListener(TouchEvent.TOUCH, onTouch);
            super.dispose();
        }
    }
}