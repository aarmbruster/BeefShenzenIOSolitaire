using Atma;
using System;

namespace BeefShenzenIOSolitaire.Entities
{
	public class CardHolder : Card
	{
		public enum HolderType
		{
			Stack,
			Temp,
			Rose,
			Resolved
		}

		public readonly HolderType holder_type;

		public this(CardType card_type, String name, HolderType holder_type) : base(card_type, name)
		{
			this.holder_type = holder_type;
			//Console.WriteLine("Holder card_type {0} | card_state {1}", card_type, card_state);
			//card_back = Components.Add(new Sprite(Core.Atlas["main/card_back"]));
		}

		public override float2 GetChildOffset(Card in_child)
		{
			return float2.Zero;
		}
	}
}
