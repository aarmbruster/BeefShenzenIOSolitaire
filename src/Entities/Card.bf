using Atma;
using System;

namespace BeefShenzenIOSolitaire.Entities
{
	public class Card : Entity
	{
		private Sprite cardBack;
		private Sprite cardFront;

		public this() : base ("Card")
		{
			cardBack = Components.Add(new Sprite(Core.Atlas["main/card_front"]));
			cardBack.SetDepth(1.0f);

			cardFront = Components.Add(new Sprite(Core.Atlas["main/coins_1"]));
			cardFront.SetDepth(1.1f);

		}	
	}
}
