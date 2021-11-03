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
		public Card child {get; private set;}
		public Card parent{get; private set;}

		public CollisionComponent collision;

		public  CardState card_state = .Stacked;
		public List<Card> column;

		private Sprite card_back;
		private Sprite card_front;
		private Sprite card_number;
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
			card_number = Components.Add(new Sprite(Core.Atlas["main/number_2"]));
			card_number.SetDepth(0.2f);
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

		public virtual void OnPickedUp(uint8 in_depth, float2 input_offset)
		{
			SetDepth(in_depth);
			this.input_offset = input_offset;
			if(child != null)
			{
				child.OnPickedUp(in_depth + 1, input_offset);
			}

			card_state = .PickedUp;
			picked_up_pos = this.Position;
		}

		public void OnDropped()
		{
			card_state = .Stacked;
			if(child!=null)
				((Card)child).OnDropped();
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

		public bool IsChildNumberOneLess()
		{
			if((int)this.card_type > 2 || (int)child.card_type > 2) // Make sure this and it's child are numbered cards
				return false;

			let num_child = (NumberCard)child;
			let num_card = (NumberCard)this;
			if(num_child!=null && num_card!=null)
			{
				return num_card.card_num - num_child.card_num == 1;
			}
			return false;
		}

		public bool IsChildOffSuite()
		{
			int ct = (int)card_type;
			int cct = (int)child.card_type;
			return cct < 3 && ct != cct;
		}

		public bool IsChildPickupValid()
		{
			if(child==null)
				return true;
			else if(IsChildNumberOneLess() && IsChildOffSuite())
				return true;
			return false;
		}

		public override bool CanPickUp()
		{
			switch(card_state)
			{
			case .Stacked:
				return IsChildPickupValid();
			case .Resolved:
				return false;
			case .Temped:
				 return true;
			case .PickedUp:
				return false;
			}
		}

		public virtual bool SetChild(Card new_child)
		{
			bool child_was_set = false;
			if(child == null)
			{
				child = new_child;
				new_child.MoveToWorld(this.Position + GetChildOffset((Card)new_child));
				new_child.SetDepth(this.Depth + 1);
				child_was_set = true;
			}
			return child_was_set;
		}

		public virtual void SetState(CardState new_state)
		{
			this.card_state = new_state;
		}

		public virtual float2 GetChildOffset(Card in_child)
		{
			return float2(0, CardManager.card_offset);
		}

		public void RemoveChild()
		{
			child = null;
		}

		public virtual void SetParent(Card new_parent)
		{
			parent = new_parent;
		}

		public void SetDepth(float in_depth)
		{
			this.Depth = in_depth;
		}

		public void MoveToWorld(float2 new_world_pos)
		{
			Position = new_world_pos;
			if(child != null)
				child.MoveToWorld(new_world_pos + float2(0.0f, 36.0f));
		}
	}
}
