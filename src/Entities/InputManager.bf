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

		protected void CheckCardClick(Atma.MouseButtons mouse_button)
		{
			if(mouse_button == .Left)
			{
				Card card = null;
				var highest_depth = -1;
				for(var col in Scene.CollisionComponents)
				{
					if(col.WorldBounds.Intersects(input_axis))
					{
						Card temp = (Card)col.Entity;
						let current_depth = temp.column.IndexOfAlt<Card>(temp);
						if(highest_depth < current_depth && temp != null && temp.CanPickUp())
						{
							highest_depth = current_depth;
							card = temp;
						}
					}
				}
				if(card != null)
				{
					picked_entity = card;
					card.OnPickedUp(CardManager.pcd(), input_axis - card.WorldPosition);
					Console.WriteLine("hello");
				}
			} else if(mouse_button == .Right)
			{
				for(var col in Scene.CollisionComponents)
				{
					if(col.WorldBounds.Intersects(input_axis))
					{
						Console.WriteLine("Entity Name: {}", col.Entity.Name);
						return;
					}
				}
			}
		}

		protected void CheckCardRelease(Atma.MouseButtons mouse_button)
		{
			if(mouse_button == .Left && picked_entity != null)
			{
				for(var column in CardManager.columns)
				{
					let highest_depth = -1;
					if(column != picked_entity.column && column.Back.collision.WorldBounds.Intersects(picked_entity.collision.WorldBounds))
					{
						picked_entity.column.Remove(picked_entity);
						picked_entity.parent.RemoveChild();
						Card parent = column.Back;
						picked_entity.SetParent(parent);
						picked_entity.SetColumn(column);
						parent.SetChild(picked_entity);
						picked_entity.OnDropped();
						picked_entity = null;
						
						return;
					}
				}
				picked_entity.MovetoWorld(picked_entity.picked_up_pos);
				picked_entity.OnDropped();
				picked_entity = null;
			}
		}

		protected override void OnUpdate()
		{
			base.OnUpdate();
			if(Core.Input.MousePressed(.Left) && !mouseDown)
			{
				mouseDown = true;
				CheckCardClick(.Left);
			}

			if(Core.Input.MouseReleased(.Left) && mouseDown)
			{
				mouseDown = false;
				CheckCardRelease(.Left);
			}

			if(Core.Input.MousePressed(.Right) && !mouseDown)
			{
				////mouseDown = true;
				//CheckCardClick(.Right);
			}

			if(Core.Input.MouseReleased(.Right) && mouseDown)
			{
				//mouseDown = false;
			}

			if(Core.Input.KeyCheck(Atma.Keys.S))
			{
				List<Card> sorted_cards = CardManager.Cards();
				Console.WriteLine("Collision Sort Before");
				Sort.SortByDepth<Card>(sorted_cards);
				Console.WriteLine("Collision sort After");
			}

			if(picked_entity != null)
			{
				picked_entity.MovetoWorld(input_axis - picked_entity.input_offset);
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
