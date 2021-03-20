using Atma;
using System;

namespace BeefShenzenIOSolitaire.Entities
{
	public class CardHolder : Card
	{
		public this(CardType card_type, String name) : base(card_type, name)
		{

		}

		public override void SetChild(Entity new_child)
		{
			if(child == null) child = new_child;
			child.Position = this.Position + float2(0, 0.f);
		}
	}
}
