package views
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class Grid extends Sprite
	{
		public function Grid() {}
		
		public function draw():void
		{
			var point:Point;
			var i:int;
			var parent:Farm = this.parent.parent as Farm;

			this.graphics.lineStyle(1, 0xCCCCCC);
			
			// draw rows
			for (i = 0; i <= parent.getRowCount(); i++)
			{
				point = getCoords(i, 0);
				this.graphics.moveTo(point.x, point.y);
				
				point = getCoords(i, parent.getColCount());
				this.graphics.lineTo(point.x, point.y);
			}
			
			// draw columns
			for (i = 0; i <= parent.getColCount(); i++)
			{
				point = getCoords(0, i);
				this.graphics.moveTo(point.x, point.y);
				
				point = getCoords(parent.getColCount(), i);
				this.graphics.lineTo(point.x, point.y);
			}
		}
		
		public function getCoords(row:int, column:int):Point
		{
			var result:Point = new Point();
			
			// rotate
			// x' = x*cos(a) - y*sin(a)
			// y' = x*sin(a) + y*cos(a)
			result.x = (column * Constants.COL_WIDTH) * Math.cos(Constants.ROTATE_ANGLE) + 
				       (row * Constants.ROW_HEIGHT) * Math.sin(Constants.ROTATE_ANGLE);
			result.y = (column * Constants.COL_WIDTH) * Math.sin(Constants.ROTATE_ANGLE) - 
				       (row * Constants.ROW_HEIGHT) * Math.cos(Constants.ROTATE_ANGLE);
			
			// compression
			result.y *= Constants.COMPRESSION;
			
			// shift
			result.x += Constants.FIELD_X0_PX;
			result.y += Constants.FIELD_Y0_PX;
			
			return result;
		}
		
		public function getCell(x:Number, y:Number):Point
		{
			var result:Point = new Point();
			var parent:Farm = this.parent.parent as Farm;
			
			x -= Constants.FIELD_X0_PX;
			y -= Constants.FIELD_Y0_PX;
			
			// uncompress
			y /= Constants.COMPRESSION;
			
			// rotate
			result.x = x * Math.cos(Constants.ROTATE_ANGLE) + 
				       y * Math.sin(Constants.ROTATE_ANGLE);
			result.y = x * Math.sin(Constants.ROTATE_ANGLE) - 
				       y * Math.cos(Constants.ROTATE_ANGLE);
			
			// outside field
			if ((result.x < 0) || (result.y < 0))
				return null;
			else if ((result.x > (parent.getColCount() * Constants.COL_WIDTH)) || 
					 (result.y > (parent.getRowCount() * Constants.ROW_HEIGHT)))
				return null;
			
			// get row and column indexes
			result.x = (int)(result.x / Constants.COL_WIDTH);
			result.y = (int)(result.y / Constants.ROW_HEIGHT);
			
			return result;
		}
	}
}
