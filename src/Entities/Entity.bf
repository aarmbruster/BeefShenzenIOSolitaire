using System;

namespace Atma
{
	public extension Entity
	{
		/*public aabb2 local_bounds;
		public aabb2 world_bounds;

		public float GetWidth()
		{
			return local_bounds.Width;
		}

		public float GetHeight()
		{
			return local_bounds.Height;
		}*/

		public virtual void OnCursorEnter() { }

		public virtual void OnCursorExit() {}

		public virtual void OnMouseDown() { }

		public virtual void OnMouseUp() { }

		/*protected override new void OnFixedUpdate()
		{
			base.OnFixedUpdate();
			Console.WriteLine("Name: {}", this.Name);
		}*/
	}
}
