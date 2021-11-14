using Atma;
using System;
using Atma.Entities.Components;

namespace BeefShenzenIOSolitaire.Entities
{
	enum SpecialButtonState
	{
		unsolved,
		solvable,
		solved
	}

	public class SpecialButton : Entity
	{
		public SpecialButtonState button_state {get; private set;}

		public CardType card_association {get; private set;}

		private Sprite down;
		private Sprite up;
		private Sprite active;

		public CollisionComponent collision {get; protected set;}

		public this(String name, float2 pos, CardType card_type) : base ("Button")
		{
			card_association = card_type;

			up = Components.Add(new Sprite(Core.Atlas[scope $"main/button_{name}_up"]));
			down = Components.Add(new Sprite(Core.Atlas[scope $"main/button_{name}_down"]));
			active = Components.Add(new Sprite(Core.Atlas[scope $"main/button_{name}_active"]));

			down.Visible = false;
			active.Visible = false;

			Position = pos;

			collision = Components.Add(new CollisionComponent(true));
			collision.Added(this);
			collision.LocalBounds = aabb2.FromDimensions(float2(0.0f, 0.0f), float2(72, 71));
		}

		public void SetMode(bool is_solvable)
		{
			if(is_solvable)
			{
				up.Visible = false;
				active.Visible = true;
				button_state = .solvable;
			}
		}

		public override void OnMouseDown()
		{
			base.OnMouseDown();
			if(this.button_state == .solvable)
			{
				down.Visible = true;
				active.Visible = up.Visible = false;
			} else
			{
				up.Visible = true;
				active.Visible = down.Visible = false;
			}
		}

		public override void OnMouseUp()
		{
			base.OnMouseUp();

			Console.WriteLine("Card Association: {0}", card_association);
			CardHolder holder = null;
			if(CardManager.CanResolveSpecials(card_association, ref holder))
			{
				if(holder != null)
				{
					CardManager.ResolveSpecial(card_association, holder);
				}
			}
			up.Visible = true;
			active.Visible = down.Visible = false;
		}
	}
}
