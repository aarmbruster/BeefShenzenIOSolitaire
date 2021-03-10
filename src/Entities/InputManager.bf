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

		public void MouseDown() {}

		public void MouseUp() {}

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
