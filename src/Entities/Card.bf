using Atma;
using BeefShenzenIOSolitaire;
using Atma.Entities.Components;
using System.Collections;
using System;

namespace BeefShenzenIOSolitaire.Entities
{
	enum CardType
	{
		Coin,
		Bamboo,
		Char,
		Green,
		Red,
		White,
		Flower,
		Holder
	}

	enum CardState
	{
		Stacked,
		Temped,
		Resolved,
		PickedUp
	}

	public struct BaseCardInfo
	{
		public String card_name;
		public CardType card_type;
		public this(CardType card_type, String card_name)
		{
			this.card_name = card_name;
			this.card_type = card_type;
		};
	}

	public struct NumberCardInfo : BaseCardInfo
	{
		public uint8 card_num;
		public this(CardType card_type, String card_name, uint8 card_num) : base(card_type, card_name)
		{
			this.card_num = card_num;
		}
	}

	public abstract class Card : Entity
	{
		public CollisionComponent collision;

		public  CardState card_state = .Stacked;
		public List<Card> column;

		private Sprite card_back;
		private Sprite card_front;
		private CardType card_type;
		private String card_name;
		private bool isMousedOver = false;
		private bool isMovable = false;
		private bool isPickedUp = false;
		public float2 picked_up_pos{get; private set;}

		public this(CardType card_type, String name) : base (name)
		{
			this.card_type = card_type;
			collision = Components.Add(new CollisionComponent(true));
			collision.LocalBounds = aabb2.FromDimensions(float2(0.0f, 0.0f), float2(122.0f, 237.0f));
		}

		public this(BaseCardInfo card_info) : base (card_info.card_name)
		{
			this.card_type = card_info.card_type;
			this.card_name = card_info.card_name;
			
			card_back = Components.Add(new Sprite(Core.Atlas["main/card_front"]));
			card_front = Components.Add(new Sprite(Core.Atlas[card_name]));
			card_front.SetDepth(0.1f);
			collision = Components.Add(new CollisionComponent(true));
			collision.LocalBounds = card_back.LocalBounds;
		}

		public virtual float GetChildOffset()
		{
			return CardManager.card_offset;
		}

		public void SetColumn(List<Card> in_column)
		{
			if(column != null)
				column.Remove(this);

			column = in_column;
			column.Add(this);
			float depth = column.Count;
			this.SetDepth(depth);

			if(child != null)
				((Card)child).SetColumn(in_column);
		}

		public override void OnPickedUp(uint8 in_depth, float2 input_offset)
		{
			base.OnPickedUp(in_depth, input_offset);
			card_state = .PickedUp;
			picked_up_pos = this.Position;
		}

		public void OnDropped()
		{
			card_state = .Stacked;
		}

		protected override void OnUpdate()
		{
			base.OnUpdate();
		}

		public override void OnCursorEnter()
		{
			base.OnCursorEnter();
			this.isMousedOver = true;
			//Console.WriteLine("Cursor enter: {}", this.card_name);
		}

		public override void OnCursorExit()
		{
			base.OnCursorExit();
			isMousedOver = false;
			//Console.WriteLine("Cursor exit: {}", this.card_name);
		}

		protected override void OnFixedUpdate()
		{
			base.OnFixedUpdate();
		}

		public override void OnMouseDown()
		{
			base.OnMouseDown();
		}

		public override void OnMouseUp()
		{
			base.OnMouseUp();
		}

		public override bool CanPickUp()
		{
			switch(card_state)
			{
			case .Stacked:
				return true;
			case .Resolved:
				return false;
			case .Temped:
				 return true;
			case .PickedUp:
				return false;
			}
		}

		public override void SetChild(Entity new_child)
		{
			base.SetChild(new_child);
			new_child.MovetoWorld(this.Position + GetChildOffset((Card)new_child));
			new_child.SetDepth(this.Depth + 1);
		}

		public virtual void SetState(CardState new_state)
		{
			this.card_state = new_state;
		}

		public virtual float2 GetChildOffset(Card in_child)
		{
			return float2(0, CardManager.card_offset);
		}
	}
}
