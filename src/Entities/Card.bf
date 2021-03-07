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
		Flower
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

		private Sprite card_back;
		private Sprite card_front;
		private CardType card_type;
		private String card_name;
		private bool isMousedOver = false;
		private bool isPickedUp = false;
		
		public this(BaseCardInfo card_info) : base (card_info.card_name)
		{
			this.card_type = card_info.card_type;
			this.card_name = card_info.card_name;
			card_front = Components.Add(new Sprite(Core.Atlas[card_name]));
			card_back = Components.Add(new Sprite(Core.Atlas["main/card_front"]));
			collision = Components.Add(new CollisionComponent(true));
			collision.LocalBounds = card_back.LocalBounds;
			///Scene.RegisterCollision(collision);
			//collision = rect.FromDimensions(int2((int)Position.x, (int)Position.y), (int)card_back.Width, (int)card_back.Height);
			//collision = aabb2.FromDimensions(Position, float2(card_back.Width, card_back.Height);
		}

		protected override void OnUpdate()
		{
			base.OnUpdate();

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
