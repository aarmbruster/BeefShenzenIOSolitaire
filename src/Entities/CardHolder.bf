using Atma;
using System;

namespace BeefShenzenIOSolitaire.Entities
{
	public class CardHolder : Card
	{
		//Sprite card_back;

		public this(CardType card_type, String name) : base(card_type, name)
		{
			//card_back = Components.Add(new Sprite(Core.Atlas["main/card_back"]));
		}

		public override float2 GetChildOffset(Card in_child)
		{
			return float2.Zero;
		}
	}
}
