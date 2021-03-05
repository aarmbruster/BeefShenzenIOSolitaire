using Atma;
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
		private Sprite card_back;
		private Sprite card_front;
		private CardType card_type;
		private String card_name;

		public this(BaseCardInfo card_info) : base (card_info.card_name)
		{
			this.card_type = card_info.card_type;
			this.card_name = card_info.card_name;
			card_front = Components.Add(new Sprite(Core.Atlas[card_name]));
			card_back = Components.Add(new Sprite(Core.Atlas["main/card_front"]));
		}

		public ~this()
		{
			Console.WriteLine("Destructing");
		}
	}
}
