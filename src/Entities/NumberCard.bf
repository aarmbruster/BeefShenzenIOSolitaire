
using System;
using System.Collections;
using Atma;

namespace BeefShenzenIOSolitaire.Entities
{
	
	public class NumberCard : Card
	{
		public uint8 card_num;
		private Sprite card_top_num;
		private Sprite card_bottom_num;

		private static readonly List<String> card_nums = new List<String>(String[?](
			"main/number_1",
			"main/number_2",
			"main/number_3",
			"main/number_4",
			"main/number_5",
			"main/number_6",
			"main/number_7",
			"main/number_8",
			"main/number_9"
		))  ~ delete _;

		//public SpriteFont font ~Release(_);
		//private Sprite num_sprite;
		//private List<Atma.SpriteFont.Glyph> glyphs = new List<Atma.SpriteFont.Glyph>() ~delete _;
		//private Texture texture = new Texture(1024, 1024, TextureFormat.RGBA16F);

		public this(NumberCardInfo card_info) : base (card_info)
		{
			card_num = card_info.card_num;
			//Create top card num indicator
			card_top_num = Components.Add(new Sprite(Core.Atlas[card_nums[card_info.card_num - 1]]));
			card_top_num.SetDepth(0.2f);

			card_top_num.Y = -101;
			card_top_num.X = -36;

			//Create bottom card num indicator
			card_bottom_num = Components.Add(new Sprite(Core.Atlas[card_nums[card_info.card_num - 1]]));
			card_bottom_num.SetDepth(0.2f);

			card_bottom_num.SpriteRotation = 0.5f;
			card_bottom_num.Y = 101;
			card_bottom_num.X = 36;
			
			top_indicator = Components.Add(GetCardIndicator(card_info.card_type));
			top_indicator.X = -44;
			top_indicator.Y = -76f;
			top_indicator.SetDepth(0.3f);
			bottom_indicator = Components.Add(GetCardIndicator(card_info.card_type));
			bottom_indicator.X = 44;
			bottom_indicator.Y = 76;
			bottom_indicator.SetDepth(0.3f);
			bottom_indicator.SpriteRotation = 0.5f;

			if(card_info.card_type == .Bamboo)
			{
				card_top_num.Tint = card_bottom_num.Tint = Colors.Green;
				card_front.Tint = Colors.Green;
				bottom_indicator.Tint = Colors.Green;
				top_indicator.Tint = Colors.Green;
			}
			else if (card_info.card_type == .Char)
			{
				card_top_num.Tint = card_bottom_num.Tint = Colors.Black;
			}
			else if (card_info.card_type == .Coin)
			{
				card_top_num.Tint = card_bottom_num.Tint = Colors.Red;
			}
		}

		public override Sprite GetCardIndicator(CardType in_card_type)
		{
			if(in_card_type == .Char)
			{
				return new Sprite(Core.Atlas["main/characters_sm"]);
			}
			else if (in_card_type == .Coin)
			{
				return new Sprite(Core.Atlas["main/coins_sm"]);
			}
			else
			{
				return new Sprite(Core.Atlas["main/bamboo_sm"]);
			}
		}
	}
}
