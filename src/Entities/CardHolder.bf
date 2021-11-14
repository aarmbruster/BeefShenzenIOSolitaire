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
			// for debug
			//card_back = Components.Add(new Sprite(Core.Atlas["main/card_front"]));
			this.holder_type = holder_type;
		}

		public override float2 GetChildOffset(Card in_child)
		{
			return float2.Zero;
		}
	}
}
