using Atma;
using System;
using Atma.Entities.Components;
using System.Collections;
using BeefShenzenIOSolitaire.Entities;

namespace BeefShenzenIOSolitaire.Entities
{
	public class InputManager : Entity
	{
		public float2 input_axis;
		public Entity focused_entity;

		private bool mouseDown = false;

		private Card picked_entity;

		public void MouseDown() {}

		public void MouseUp() {}

		protected void CheckCardClick()
		{
			for(var col in Scene.CollisionComponents)
			{
				if(col.WorldBounds.Intersects(input_axis))
				{
					Card card = (Card)col.Entity;
					if(card != null)
					{
						picked_entity = card;
						card.OnPickedUp(CardManager.pcd(), input_axis - card.WorldPosition);
					}
					
					return;
				}
			}
		}

		protected void CheckCardRelease()
		{
			if(picked_entity != null)
			{
				for(var column in CardManager.columns)
				{
					/*if(col.Entity != picked_entity && col.WorldBounds.Intersects(input_axis))
					{
						if(col.Entity == focused_entity)
							return;
						if(focused_entity != null)
							focused_entity.OnCursorExit();
						focused_entity = col.Entity;
						col.Entity.OnCursorEnter();
						return;
					}*/
				}
			}
		}

		protected override void OnUpdate()
		{
			base.OnUpdate();
			if(Core.Input.MousePressed(.Left) && !mouseDown)
			{
				mouseDown = true;
				CheckCardClick();
			}

			if(Core.Input.MouseReleased(.Left) && mouseDown)
			{
				mouseDown = false;
			}

			if(picked_entity != null)
			{
				picked_entity.MovetoWorld(input_axis);
			}	
		}

		protected override new void OnFixedUpdate()
		{
			base.OnFixedUpdate();
			for(var col in Scene.CollisionComponents)
			{
				if(col.WorldBounds.Intersects(input_axis))
				{
					if(col.Entity == focused_entity)
						return;
					if(focused_entity != null)
						focused_entity.OnCursorExit();
					focused_entity = col.Entity;
					col.Entity.OnCursorEnter();
					return;
				}
			}
			if(focused_entity != null)
				focused_entity.OnCursorExit();
			focused_entity = null;
		}
	}
}
