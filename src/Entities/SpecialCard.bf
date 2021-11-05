using Atma;

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

			top_indicator = Components.Add(GetCardIndicator(card_info.card_type));
			top_indicator.X = -45;
			top_indicator.Y = -96;
			top_indicator.SetDepth(0.3f);
			bottom_indicator = Components.Add(GetCardIndicator(card_info.card_type));
			bottom_indicator.X = 45;
			bottom_indicator.Y = 96;
			bottom_indicator.SetDepth(0.3f);
			bottom_indicator.SpriteRotation = 0.5f;

			if(card_info.card_type == .Green)
			{
				top_indicator.Tint = Colors.Green;
				bottom_indicator.Tint = Colors.Green;
			}
		}

		public override Sprite GetCardIndicator(CardType in_card_type)
		{
			if(in_card_type == .White)
			{
				return new Sprite(Core.Atlas["main/dragon_white_sm"]);
			}
			else if (in_card_type == .Red)
			{
				return new Sprite(Core.Atlas["main/dragon_red_sm"]);
			}
			else if (in_card_type == .Green)
			{
				return new Sprite(Core.Atlas["main/dragon_green_sm"]);
			}
			else
			{
				return new Sprite(Core.Atlas["main/flower_sm"]);
			}
		}
	}
}
