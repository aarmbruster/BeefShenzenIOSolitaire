
using System;
using System.Collections;
using Atma;

namespace BeefShenzenIOSolitaire.Entities
{
	
	public class NumberCard : Card
	{
		public uint8 card_num;
		//public SpriteFont font ~Release(_);
		//private Sprite num_sprite;
		//private List<Atma.SpriteFont.Glyph> glyphs = new List<Atma.SpriteFont.Glyph>() ~delete _;
		//private Texture texture = new Texture(1024, 1024, TextureFormat.RGBA16F);

		public this(NumberCardInfo card_info) : base (card_info)
		{
			card_num = card_info.card_num;
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
