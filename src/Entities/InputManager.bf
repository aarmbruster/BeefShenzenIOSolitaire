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
		private bool mouse_down_l = false;
		private bool mouse_down_r = false;
		private Card picked_entity;

		public void MouseDown() {}
		public void MouseUp() {}

		private bool keyDown = false;

		protected void CheckCardClick(Atma.MouseButtons mouse_button)
		{
			if(mouse_button == .Left || mouse_button == .Right)
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
				}
			}
		}

		protected void CheckCardRelease(Atma.MouseButtons mouse_button)
		{
			if(mouse_button == .Right && picked_entity != null)
			{
				picked_entity.MoveToWorld(float2(-10, -10));
				if(picked_entity.IsParented)
				{
					picked_entity.parent.SetChild(null);
				}
				
				picked_entity.SetParent(null);
				picked_entity.column.Remove(picked_entity);
				picked_entity.column = null;
				picked_entity.OnDropped();
				picked_entity = null;
			}

			if(mouse_button == .Left && picked_entity != null)
			{
				for(var column in CardManager.columns)
				{
					// check collision
					if(column != picked_entity.column && column.Back.collision.WorldBounds.Intersects(picked_entity.collision.WorldBounds))
					{
						bool can_be_dropped_on = picked_entity.CanBeDroppedOn(column.Back);
						if(can_be_dropped_on)
						{
							picked_entity.Drop(column.Back);
							picked_entity = null;
							return;
						}
						
					}
				}
				picked_entity.Drop(picked_entity.parent);
				picked_entity.MoveToWorld(picked_entity.picked_up_pos);
				picked_entity.OnDropped();
				picked_entity = null;
			}
		}

		protected override void OnUpdate()
		{
			base.OnUpdate();

			if(Core.Input.MousePressed(.Left) && !mouse_down_l)
			{
				mouse_down_l = true;
				CheckCardClick(.Left);
			}

			if(Core.Input.MouseReleased(.Left) && mouse_down_l)
			{
				mouse_down_l = false;
				CheckCardRelease(.Left);
			}

			if(Core.Input.MousePressed(.Right) && !mouse_down_r)
			{
				mouse_down_r = true;
				CheckCardClick(.Right);
			}

			if(Core.Input.MouseReleased(.Right) && mouse_down_r)
			{
				mouse_down_r = false;
				CheckCardRelease(.Right);
			}

			if(Core.Input.KeyCheck(Atma.Keys.C))
			{
				List<Card> sorted_cards = CardManager.Cards();
				Console.WriteLine("Collision Sort Before");
				Sort.SortByDepth<Card>(sorted_cards);
				Console.WriteLine("Collision sort After");
			}

			if(picked_entity != null)
			{
				picked_entity.MoveToWorld(input_axis - picked_entity.input_offset);
			}	
		}

		protected override new void OnFixedUpdate()
		{
			base.OnFixedUpdate();
			for(var col in Scene.CollisionComponents)
			{
				if(col.WorldBounds.Intersects(input_axis))
				{
					if(col.Entity == CardManager.focused_entity)
						return;
					if(CardManager.focused_entity != null)
						CardManager.focused_entity.OnCursorExit();
					CardManager.focused_entity = col.Entity;
					col.Entity.OnCursorEnter();
					return;
				}
			}
			if(Core.Input.KeyCheck(Atma.Keys.S) && !keyDown)
			{
				Console.WriteLine("hello");
				keyDown = true;
				BeefShenzenIOSolitaire scene = (BeefShenzenIOSolitaire)CardManager.game_scene;
				CardManager.reset_cards();
				scene.get_card_manager().shuffle_cards(0);
				scene.get_card_manager().place_cards(scene);
			}
			else if(!Core.Input.KeyCheck(Atma.Keys.S) && keyDown)
			{
				keyDown = false;
			}

			if(CardManager.focused_entity != null)
				CardManager.focused_entity.OnCursorExit();
			CardManager.focused_entity = null;
		}
	}
}
