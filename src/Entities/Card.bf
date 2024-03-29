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
		None,
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
		private float2 _start_position;
		private float2 _desired_position;
		public bool is_lerping {get; private set;};
		private float _lerp_progress = 0;
		private float _lerp_amount = 0.1f;

		public bool IsParented => CardParent != null;
		public Card CardParent {get; private set;};
		public Card CardChild {get; private set;};

		public bool HasChild => CardChild != null;

		public CollisionComponent collision;

		protected CardState card_state = .None;
		public List<Card> column;

		protected Sprite card_front;
		protected Sprite card_back;
		protected Sprite card_indicator;

		protected Sprite top_indicator;
		protected Sprite bottom_indicator;
		
		public CardType card_type {get; protected set;}

		private SoundEffect card_swipe;
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
			
			card_back = Components.Add(new Sprite(Core.Atlas["main/card_back"]));
			card_back.Visible = false;
			card_front = Components.Add(new Sprite(Core.Atlas["main/card_front"]));
			card_indicator = Components.Add(new Sprite(Core.Atlas[card_name]));
			card_indicator.SetDepth(0.1f);

			collision = Components.Add(new CollisionComponent(true));
			collision.LocalBounds = card_front.LocalBounds;

			card_swipe = Core.Assets.LoadSoundEffect(scope $"sounds/card_sweep.wav");
		}

		public void SetColumn(List<Card> in_column)
		{
			if(column != null)
				column.Remove(this);

			column = in_column;
			column.Add(this);
			float depth = column.Count;
			this.SetDepth(depth);

			if(HasChild)
				CardChild.SetColumn(in_column);
		}

		public virtual void OnPickedUp(uint8 in_depth, float2 input_offset)
		{
			SetDepth(in_depth);
			this.input_offset = input_offset;
			if(HasChild) CardChild.OnPickedUp(in_depth + 1, input_offset);

			card_state = .PickedUp;
			picked_up_pos = this.Position;
		}

		public virtual bool CanBeDroppedOn(Card new_parent)
		{
			return true;
		}

		public void RemoveCardChild(Card in_child)
		{
			CardChild = null;
		}

		public void Drop(Card new_parent, bool use_lerping = true)
		{
			card_swipe.Play(0, 0, 0);

			if(this.column!=null)
				this.column.Remove(this);
			if(IsParented)
				this.CardParent.RemoveCardChild(this);
			List<Card> column = new_parent.column;
			this.SetCardParent(new_parent);
			this.SetColumn(column);
			new_parent.SetChild(this, use_lerping);
			this.UpdateState();
			this.SetDepth(new_parent.Depth + 1);
			if(HasChild) CardChild.Drop(this, false);
		}

		public virtual void UpdateState(bool atomic = false)
		{
			if(card_state == .Resolved && !atomic)
				return;

			SetState(.Stacked);
			if(IsParented)
			{
				SetDepth(this.CardParent.Depth + 1);
				if(CardParent.GetCardType() == .Holder)
				{
					let holder = CardParent as CardHolder;
					if(holder.holder_type == .Temp)
					{
						SetState(.Temped);
					}

					if(holder.holder_type == .Resolved)
					{
						SetState(.Resolved);
					}
				}
			}
		}

		protected override void OnUpdate()
		{
			if(is_lerping)
			{
				MoveToWorld(Math.Lerp<float2>(_start_position, _desired_position, _lerp_progress));
				if(_lerp_progress >= 1)
				{
					is_lerping = false;
					_lerp_progress = 0;
					return;
				}
				_lerp_progress += _lerp_amount;
			}
		}

		public override void OnCursorEnter()
		{
			base.OnCursorEnter();
			this.isMousedOver = true;
		}

		public override void OnCursorExit()
		{
			base.OnCursorExit();
			isMousedOver = false;
		}

		public bool IsChildNumberOneLess()
		{
			if((int)this.card_type > 2 || (int)CardChild.card_type > 2) // Make sure this and it's child are numbered cards
				return false;

			let num_child = CardChild as NumberCard;
			let num_card = this as NumberCard;
			if(num_child!=null && num_card!=null)
			{
				return num_card.card_num - num_child.card_num == 1;
			}
			return false;
		}

		public bool IsChildOffSuite()
		{
			let ct = (int)card_type;
			let cct = (int)CardChild.card_type;
			return cct < 3 && ct != cct;
		}

		public bool IsDifferentSuite(Card b)
		{
			int ct = (int)card_type;
			int cct = (int)b.card_type;
			return cct < 3 && ct != cct; 
		}

		public bool IsSameSuite(Card b)
		{
			return card_type == b.GetCardType();
		}	

		public bool IsChildPickupValid()
		{
			if(CardChild==null)
				return true;
			else if(CardChild.IsChildPickupValid() && IsChildNumberOneLess() && IsChildOffSuite())
				return true;
			return false;
		}

		public override bool CanPickUp()
		{
			switch(GetState())
			{
			case .None:
				return true;
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

		public CardType GetCardType()
		{
			return card_type;
		}

		public bool IsParentHolder(Card new_parent)
		{
			return new_parent.card_type == .Holder;
		}

		public bool IsHolderResolvedStack(Card new_parent)
		{
			if(IsParentHolder(new_parent))
			{
				return ((CardHolder)new_parent).holder_type == .Resolved;
			}
			return false;
		}

		public virtual bool SetChild(Card new_child, bool use_lerping = true)
		{
			bool child_was_set = false;
			if(!HasChild)
			{
				CardChild = new_child;
				float2 offset = GetChildOffset((Card)new_child);
				float2 new_pos = this.Position + offset;
				if(use_lerping)
					new_child.LerpToWorld(new_pos);
				else
					new_child.MoveToWorld(new_pos);
				new_child.SetDepth(this.Depth + 1);
				child_was_set = true;
			}
			CardChild = new_child;
			return child_was_set;
		}

		public virtual void SetState(CardState new_state)
		{
			this.card_state = new_state;
		}

		public CardState GetState()
		{
			return card_state;
		}

		public virtual float2 GetChildOffset(Card in_child)
		{
			return float2(0, CardManager.card_offset);
		}

		public bool IsNumberCard()
		{
			return (int)GetCardType() < 3;
		}

		public virtual void SetCardParent(Card new_parent)
		{
			CardParent = new_parent;
		}

		public void SetDepth(float in_depth)
		{
			this.Depth = in_depth;
		}

		public void LerpToWorld(float2 new_world_pos)
		{
			is_lerping = true;
			_start_position = Position;
			_desired_position = new_world_pos;
		}

		public void MoveToWorld(float2 new_world_pos)
		{
			Position = new_world_pos;
			if(CardChild != null)
			{
				CardChild.MoveToWorld(Position + float2(0.0f, 36.0f));
			}
		}

		public virtual Atma.Sprite GetCardIndicator(CardType in_card_type)
		{
			return null;
		}

		public virtual void reset()
		{
			if(this.column != null && this.card_type != .Holder)
			{
				this.column.Remove(this);
				this.column = null;
			}
				
			this.CardChild = null;
			this.CardParent = null;
		}
	}
}
