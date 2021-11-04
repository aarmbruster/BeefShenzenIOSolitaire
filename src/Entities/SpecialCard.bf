namespace BeefShenzenIOSolitaire.Entities
{
	public class SpecialCard : Card
	{
		public this(BaseCardInfo card_info) : base (card_info)
		{
			if(card_info.card_type == .Green)
			{
				card_front.Tint = Colors.Green;
			}
		}
	}
}
