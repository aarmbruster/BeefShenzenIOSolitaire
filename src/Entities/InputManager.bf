// Copyright Andrew Armbruster, All Rights Reserved
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
		private Entity picked_entity;

		public void MouseDown() {}
		public void MouseUp() {}

		private bool keyDown = false;

		protected void Pressed(Atma.MouseButtons mouse_button)
		{
			if(mouse_button == .Left || mouse_button == .Right)
			{
				Card card = null;
				var highest_depth = -1;
				for(var col in Scene.CollisionComponents)
				{
					if(col.WorldBounds.Intersects(input_axis))
					{
						if(mouse_button == .Right)
						{
							picked_entity = col.Entity;
							return;
						}

						if(SpecialButton sp = col.Entity as SpecialButton && sp.button_state == .solvable)
						{
							picked_entity = sp;
						}
						
						if(Card temp = col.Entity as Card)
						{
							let current_depth = temp.column.IndexOfAlt<Card>(temp);
							if(highest_depth < current_depth && temp != null && temp.CanPickUp())
							{
								highest_depth = current_depth;
								card = temp;
							}
						}
						col.Entity.OnMouseDown();
					}
				}
				if(card != null)
				{
					picked_entity = card;
					card.OnPickedUp(CardManager.pcd(), input_axis - card.WorldPosition);
				}
			}
		}

		protected void Release(Atma.MouseButtons mouse_button)
		{
			if(picked_entity == null)
				return;
			if(Card picked_card = picked_entity as Card)
			{
				if(mouse_button == .Right && picked_entity != null)
				{
					picked_card.MoveToWorld(float2(-10, -10));
					if(picked_card.IsParented)
					{
						picked_card.parent.SetChild(null);
					}

					picked_card.SetParent(null);
					picked_card.column.Remove(picked_card);
					picked_card.column = null;
					picked_card.UpdateState();
					picked_entity.OnMouseUp();
					picked_entity = null;
				}
	
				if(mouse_button == .Left && picked_entity != null)
				{
					for(var column in CardManager.columns)
					{
						// check collision
						if(column != picked_card.column && column.Back.collision.WorldBounds.Intersects(picked_card.collision.WorldBounds))
						{
							bool can_be_dropped_on = picked_card.CanBeDroppedOn(column.Back);
							if(can_be_dropped_on)
							{
								picked_card.Drop(column.Back);
								picked_entity = null;
								return;
							}
							
						}
					}
					picked_card.Drop(picked_card.parent);
					picked_card.MoveToWorld(picked_card.picked_up_pos);
					picked_entity.OnMouseUp();
					picked_entity = null;
				}
				
			}

			if(picked_entity != null)
				picked_entity.OnMouseUp();
		}

		protected override void OnUpdate()
		{
			base.OnUpdate();

			if(Core.Input.MousePressed(.Left) && !mouse_down_l)
			{
				mouse_down_l = true;
				Pressed(.Left);
			}

			if(Core.Input.MouseReleased(.Left) && mouse_down_l)
			{
				mouse_down_l = false;
				Release(.Left);
			}

			if(Core.Input.MousePressed(.Right) && !mouse_down_r)
			{
				mouse_down_r = true;
				Pressed(.Right);
			}

			if(Core.Input.MouseReleased(.Right) && mouse_down_r)
			{
				mouse_down_r = false;
				Release(.Right);
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
				if(Card picked_card = picked_entity as Card)
				{
					picked_card.MoveToWorld(input_axis - picked_entity.input_offset);
				}
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
				scene.get_card_manager().deal_cards(scene);
			}
			else if(!Core.Input.KeyCheck(Atma.Keys.S) && keyDown)
			{
				keyDown = false;
			}

			if(CardManager.focused_entity != null)
				CardManager.focused_entity.OnCursorExit();
			CardManager.focused_entity = null;


			CardManager.check_ends();
		}
	}
}
