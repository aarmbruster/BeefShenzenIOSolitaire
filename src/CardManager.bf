using Atma;
using System;
using System.Collections;
using BeefShenzenIOSolitaire.Entities;

namespace BeefShenzenIOSolitaire
{
	public class CardManager
	{
		private static uint8 start_card_depth = 64;
		private static uint8 picked_card_depth = 128;

		public static uint8 scd()
		{
			return start_card_depth;
		}
		public static uint8 pcd()
		{
			return picked_card_depth;
		}

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
		))  ~ delete _;

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
		))  ~ delete _;

		private List<Card> cards = new List<Card>() ~delete _;

		public static List<Column> columns = new List<Column>() ~delete _;// ~Release(_);
		
		public this()
		{

		}

		private Column GetColumn(int i)
		{
			return columns[i];
		}

		public void create_cards()
		{
			for(NumberCardInfo num_card in num_cards)
			{
				cards.Add(new NumberCard(num_card));
			}

			for(BaseCardInfo spec_card in spec_cards)
			{
				cards.Add(new SpecialCard(spec_card));
			}
		}

		public void shuffle_cards(int seed)
		{
			Random random = new Random(seed);
			random.Shuffle<Card>(cards);
			delete(random);
		}

		public void place_columns(Scene scene)
		{
			for(int i = 0; i < 8; i++)
			{
				let column = scene.AddEntity(new Column());
				column.Position = float2(i * 152.0f + 106, 284.0f);
				columns.Add(column);
			}
		}

		public void place_cards(Scene scene)
		{
			/*for(int i = 0; i < columns.Count; i++)
			{
				let card = scene.AddEntity(new CardHolder(.Holder, "Card Holder"));
				let col = GetColumn(i);
				col.AddCard(card);
				card.Depth = 0;
				card.Position = float2(i * 152.0f + 106, 365.0f + columns.Count * 36);
			}*/

			for(int i = cards.Count - 1; i >= 0; i--)
			{
				Card card = scene.AddEntity(cards[i]);
				int col_index = i%8;
				let column = GetColumn(col_index);
				card.Depth = scd() + columns[col_index].cards.Count;
				let card_count = columns[col_index].cards.Count;
				let y = 284.0f + card.collision.LocalBounds.Height * 0.5f + card_count * 36;
				card.Position = float2(col_index * 152.0f + 106, y);
				Console.WriteLine("card y position: {}", y);
				card.collision.Added(card);
				scene.RegisterCollision(card.collision);
				column.AddCard(card);
			}
		}
	}
}
