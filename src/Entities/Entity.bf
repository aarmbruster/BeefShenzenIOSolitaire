using System;

namespace Atma
{
	public extension Entity
	{
		public float2 input_offset {get; protected set;}

		public Entity child {get; private set;}
		public Entity parent{get; private set;}

		public virtual void OnCursorEnter() { }

		public virtual void OnCursorExit() {}

		public virtual void OnMouseDown() { }

		public virtual void OnMouseUp() { }

		public virtual void SetChild(Entity new_child)
		{
			if(child == null) child = new_child;
		}

		public void RemoveChild()
		{
			child = null;
		}

		public virtual void SetParent(Entity new_parent)
		{
			parent = new_parent;
		}

		public void SetDepth(float in_depth)
		{
			this.Depth = in_depth;
		}

		public void MovetoWorld(float2 new_world_pos)
		{
			Position = new_world_pos;
			if(child != null)
				child.MovetoWorld(new_world_pos + float2(0.0f, 36.0f));
		}

		public virtual void OnPickedUp(uint8 in_depth, float2 input_offset)
		{
			SetDepth(in_depth);
			this.input_offset = input_offset;
			if(child != null)
			{
				child.OnPickedUp(in_depth + 1, input_offset);
			}
		}

		public virtual bool CanPickUp()
		{
			return false;
		}

		
	}
}
