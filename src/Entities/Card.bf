using Atma;
using BeefShenzenIOSolitaire;
using Atma.Entities.Components;
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

		protected Card child;
		private Sprite card_back;
		private Sprite card_front;
		private CardType card_type;
		private String card_name;
		private bool isMousedOver = false;
		private bool isMovable = false;
		private bool isPickedUp = false;

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

		public virtual void SetChild(Card new_child)
		{
			if(child == null) child = new_child;
			child.Position = this.Position + float2(0, 36.f);
		}

		public void RemoveChild()
		{
			child = null;
		}

		protected override void OnUpdate()
		{
			base.OnUpdate();
		}

		public void MovetoWorld(float2 new_world_pos)
		{
			Position = new_world_pos;
			if(child != null)
				child.MovetoWorld(new_world_pos + float2(0.0f, 36.0f));
		}

		public override void OnCursorEnter()
		{
			base.OnCursorEnter();
			this.isMousedOver = true;
			Console.WriteLine("Cursor enter: {}", this.card_name);
		}

		public override void OnCursorExit()
		{
			base.OnCursorExit();
			isMousedOver = false;
			Console.WriteLine("Cursor exit: {}", this.card_name);
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
	}
}
