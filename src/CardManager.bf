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

		public readonly static float column_y = 284;
		public readonly static float single_y = 19;
		public readonly static float card_offset = 36;

		public static List<Card> tip_cards = new List<Card>() ~delete _;
		public static List<List<Card>> columns = new List<List<Card>>(15) ~delete _;

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

		public CardHolder[15] card_holders = .();


		//public static List<Column> columns = new List<Column>() ~delete _;// ~Release(_);
		
		public this()
		{

		}

		public ~this()
		{
			for(List<Card> l in columns)
			{
				delete(l);
			}
			columns.Clear();
		}

		private List<Card> GetColumn(int i)
		{
			return columns[i];
		}

		public void create_cards(Scene scene)
		{
			for(NumberCardInfo num_card in num_cards)
			{
				cards.Add(scene.AddEntity(new NumberCard(num_card)));
			}

			for(BaseCardInfo spec_card in spec_cards)
			{
				cards.Add(scene.AddEntity(new SpecialCard(spec_card)));
			}
		}

		public void shuffle_cards(int seed)
		{
			Random random = new Random(seed);
			random.Shuffle<Card>(cards);
			delete(random);
		}

		public void create_columns(Scene scene)
		{
			for(int i = 0; i < columns.Capacity; i++)
			{
				columns.Add(new List<Card>());
			}
		}

		public void place_cards(Scene scene)
		{
			for(int i = 0; i < 8; i++)
			{
				let card = scene.AddEntity(new CardHolder(.Holder, "Card Holder"));
				let col = GetColumn(i);
				col.Add(card);
				card.Depth = 1;
				card.Position = float2(i * 152.0f + 106, column_y + card.collision.LocalBounds.Height/2);
				card_holders[i] = card;
			}	

			for(int i = 0; i < 3; i++)
			{
				let card = scene.AddEntity(new CardHolder(.Holder, "Card Holder"));
				let col = GetColumn(i + 8);
				col.Add(card);
				card.Depth = 1;
				card.Position = float2(i * 152.0f + 106, single_y + card.collision.LocalBounds.Height/2);
				card_holders[i + 8] = card;
			}

			for(int i = 0; i < 3; i++)
			{
				let card = scene.AddEntity(new CardHolder(.Holder, "Card Holder"));
				let col = GetColumn(i + 11);
				col.Add(card);
				card.Depth = 1;
				card.Position = float2(i * 152.0f + 866, single_y + card.collision.LocalBounds.Height/2);
				card_holders[i + 11] = card;
			}
			{
				let card = scene.AddEntity(new CardHolder(.Holder, "Card Holder"));
				let col = GetColumn(14);
				col.Add(card);
				card.Depth = 1;
				card.Position = float2(674, single_y + card.collision.LocalBounds.Height/2);
				card_holders[14] = card;
			}

			for(int i = cards.Count - 1; i >= 0; i--)
			{
				int col_index = i%8;
				int card_index = i;
				
				let col = GetColumn(col_index);
				let parent = col[col.Count - 1];

				Card card = cards[card_index];
				card.SetDepth((uint8)col.Count + 1);
				col.Add(card);

				parent.SetChild(card);
				
				//card.column = column;

				//card.Depth = scd() + columns[col_index].cards.Count;
				//let card_count = columns[col_index].cards.Count;
				//let card_height = card.collision.LocalBounds.Height;
				//let y = column_y + card_height * 0.5f + card_count * card_offset;
				//card.Position = float2(col_index * 152.0f + 106, y);
				card.collision.Added(card);
				scene.RegisterCollision(card.collision);
			}
		}
	}
}
