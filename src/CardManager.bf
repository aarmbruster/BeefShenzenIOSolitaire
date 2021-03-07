using Atma;
using System;
using System.Collections;
using BeefShenzenIOSolitaire.Entities;

namespace BeefShenzenIOSolitaire
{
	public class CardManager
	{
		private static readonly List<NumberCardInfo> num_cards = new List<NumberCardInfo>(NumberCardInfo[?](
			NumberCardInfo(.Coin, "main/coins_1", 1),
			NumberCardInfo(.Coin, "main/coins_2", 2),
			NumberCardInfo(.Coin, "main/coins_3", 3),
			NumberCardInfo(.Coin, "main/coins_4", 4),
			NumberCardInfo(.Coin, "main/coins_5", 5),
			NumberCardInfo(.Coin, "main/coins_6", 6),
			NumberCardInfo(.Coin, "main/coins_7", 7),
			NumberCardInfo(.Coin, "main/coins_8", 8),
			NumberCardInfo(.Coin, "main/coins_9", 9),

			NumberCardInfo(.Bamboo, "main/bamboo_1", 1),
			NumberCardInfo(.Bamboo, "main/bamboo_2", 2),
			NumberCardInfo(.Bamboo, "main/bamboo_3", 3),
			NumberCardInfo(.Bamboo, "main/bamboo_4", 4),
			NumberCardInfo(.Bamboo, "main/bamboo_5", 5),
			NumberCardInfo(.Bamboo, "main/bamboo_6", 6),
			NumberCardInfo(.Bamboo, "main/bamboo_7", 7),
			NumberCardInfo(.Bamboo, "main/bamboo_8", 8),
			NumberCardInfo(.Bamboo, "main/bamboo_9", 9),

			NumberCardInfo(.Char, "main/char_1", 1),
			NumberCardInfo(.Char, "main/char_2", 2),
			NumberCardInfo(.Char, "main/char_3", 3),
			NumberCardInfo(.Char, "main/char_4", 4),
			NumberCardInfo(.Char, "main/char_5", 5),
			NumberCardInfo(.Char, "main/char_6", 6),
			NumberCardInfo(.Char, "main/char_7", 7),
			NumberCardInfo(.Char, "main/char_8", 8),
			NumberCardInfo(.Char, "main/char_9", 9)
		)) ~Release(_);

		private static readonly List<BaseCardInfo> spec_cards =  new List<BaseCardInfo>(BaseCardInfo[?](
			BaseCardInfo(.Green, 	"main/dragon_green"),
			BaseCardInfo(.Green, 	"main/dragon_green"),
			BaseCardInfo(.Green, 	"main/dragon_green"),
			BaseCardInfo(.Green, 	"main/dragon_green"),
			BaseCardInfo(.Red, 		"main/dragon_red"),
			BaseCardInfo(.Red, 		"main/dragon_red"),
			BaseCardInfo(.Red, 		"main/dragon_red"),
			BaseCardInfo(.Red, 		"main/dragon_red"),
			BaseCardInfo(.White, 	"main/dragon_white"),
			BaseCardInfo(.White, 	"main/dragon_white"),
			BaseCardInfo(.White, 	"main/dragon_white"),
			BaseCardInfo(.White, 	"main/dragon_white"),

			BaseCardInfo(.Flower, 	"main/flower")
		)) ~Release(_);

		private List<Card> cards;
		private List<Card> col0 = new List<Card>();
		private List<Card> col1 = new List<Card>();
		private List<Card> col2 = new List<Card>();
		private List<Card> col3 = new List<Card>();
		private List<Card> col4 = new List<Card>();
		private List<Card> col5 = new List<Card>();
		private List<Card> col6 = new List<Card>();
		private List<Card> col7 = new List<Card>();
		
		public this()
		{

		}

		public ~this()
		{
			delete(cards);
			delete (col0);
			delete (col1);
			delete (col2);
			delete (col3);
			delete (col4);
			delete (col5);
			delete (col6);
			delete (col7);
		}

		private List<Card> GetColumn(int i)
		{
			switch(i)
			{
			case 0: return col0;
			case 1: return col1;
			case 2: return col2;
			case 3: return col3;
			case 4: return col4;
			case 5: return col5;
			case 6: return col6;
			case 7: return col7;
			}
			return new List<Card>();
		}

		public void place_cards(Scene scene)
		{
			cards = new List<Card>();
			
			for(NumberCardInfo num_card in num_cards)
			{
				cards.Add(new NumberCard(num_card));
			}

			for(BaseCardInfo spec_card in spec_cards)
			{
				cards.Add(new SpecialCard(spec_card));
			}
			
			for(int i = cards.Count - 1; i >= 0; i--)
			{
				Card card = scene.AddEntity(cards[i]);
				int col_index = i%8;
				let col = GetColumn(col_index);
				col.Add(card);
				card.Depth = col.Count;
				card.Position = float2(col_index * 152.0f + 106, 366.0f + col.Count * 36);
				scene.RegisterCollision(card.collision);
			}

			num_cards.Clear();
			spec_cards.Clear();
		}
	}
}
