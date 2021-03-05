
using System;
using Atma;

namespace BeefShenzenIOSolitaire.Entities
{
	
	public class NumberCard : Card
	{
		public uint8 card_num;
		
		public this(NumberCardInfo card_info) : base (card_info)
		{
			card_num = card_info.card_num;
		}
	}
}
