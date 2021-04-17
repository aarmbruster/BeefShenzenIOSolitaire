using System;

namespace Atma
{
	public extension Entity
	{
		public float2 input_offset {get; protected set;}

		public virtual void OnCursorEnter() { }

		public virtual void OnCursorExit() {}

		public virtual void OnMouseDown() { }

		public virtual void OnMouseUp() { }

		public virtual bool CanPickUp()
		{
			return false;
		}

		
	}
}
