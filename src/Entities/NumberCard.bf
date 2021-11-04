
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

			card_top_num.Y = -100;
			card_top_num.X = -36;

			//Create bottom card num indicator
			card_bottom_num = Components.Add(new Sprite(Core.Atlas[card_nums[card_info.card_num - 1]]));
			card_bottom_num.SetDepth(0.2f);

			card_bottom_num.SpriteRotation = 0.5f;
			card_bottom_num.Y = 100;
			card_bottom_num.X = 36;


			if(card_info.card_type == .Bamboo)
			{
				card_top_num.Tint = card_bottom_num.Tint = Colors.Green;
				card_front.Tint = Colors.Green;
			} else if (card_info.card_type == .Char)
			{
				card_top_num.Tint = card_bottom_num.Tint = Colors.Black;
			}
			else if (card_info.card_type == .Coin)
			{
				card_top_num.Tint = card_bottom_num.Tint = Colors.Red;
			}
			



			//font = Core.DefaultFont;
			
			//font = new SpriteFont(texture, glyphs, 'a', 1);
			
			//String str = new String();
			//font.ToString(str);
			//Console.WriteLine("font: {}", str);
			//delete(str);
			
			//num_sprite = Components.Add(new Sprite(texture));



			///font.Texture = Components.Add(Core.Atlas["main/"]);
			//"main/notoserif_cjk_regular"
		}
	}
}
