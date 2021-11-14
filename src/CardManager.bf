using Atma;
using System;
using System.Collections;
using BeefShenzenIOSolitaire.Entities;

namespace BeefShenzenIOSolitaire
{
	public class CardManager
	{
		public static BeefShenzenIOSolitaire game_scene {get; protected set;}

		public static Entity focused_entity;

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
		public readonly static float card_offset = 35;

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

		private static List<Card> cards = new List<Card>() ~delete _;

		public static CardHolder[15] card_holders = .();

		public static List<Card> Cards()
		{
			return cards;
		}

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

		private List<Card> get_column(int i)
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

		public void setup_holders(Scene scene)
		{
			game_scene = (BeefShenzenIOSolitaire)scene;
			// place the stacked card holders
			for(int i = 0; i < 8; i++)
			{
				let card = scene.AddEntity(new CardHolder(.Holder, "Card Holder", .Stack));
				let col = get_column(i);
				card.column = col;
				col.Add(card);
				card.Depth = 1;
				card.Position = float2(i * 152.0f + 106, column_y + card.collision.LocalBounds.Height/2);
				card_holders[i] = card;
			}	

			// place the temp card holders
			for(int i = 0; i < 3; i++)
			{
				let card = scene.AddEntity(new CardHolder(.Holder, "Card Holder", .Temp));
				let col = get_column(i + 8);
				card.column = col;
				col.Add(card);
				card.Depth = 1;
				card.Position = float2(i * 152.0f + 106, single_y + card.collision.LocalBounds.Height/2);
				card_holders[i + 8] = card;
			}

			// place the resolved card holders
			for(int i = 0; i < 3; i++)
			{
				let card = scene.AddEntity(new CardHolder(.Holder, "Card Holder", .Resolved));
				let col = get_column(i + 11);
				card.column = col;
				col.Add(card);
				card.Depth = 1;
				card.Position = float2(i * 152.0f + 866, single_y + card.collision.LocalBounds.Height/2);
				card_holders[i + 11] = card;
			}

			// place the flower card holder
			{
				let card = scene.AddEntity(new CardHolder(.Holder, "Card Holder", .Rose));
				let col = get_column(14);
				card.column = col;
				col.Add(card);
				card.Depth = 1;
				card.Position = float2(674, single_y + card.collision.LocalBounds.Height/2);
				card_holders[14] = card;
			}
		}

		public void place_cards(Scene scene)
		{
			// place the cards
			for(int i = cards.Count - 1; i >= 0; i--)
			{
				int col_index = i%8;
				int card_index = i;
				
				let col = get_column(col_index);
				let parent = col[col.Count - 1];

				Card card = cards[card_index];
				card.SetState(.Stacked);
				card.column = col;
				card.SetDepth((uint8)col.Count + 1);
				col.Add(card);

				parent.SetChild(card);
				card.SetParent(parent);
				
				card.collision.Added(card);
				scene.RegisterCollision(card.collision);
			}

			check_ends();
		}

		public static void reset_cards()
		{
			for(Card card in cards)
			{
				card.reset();
			}

			for(List<Card> column in columns)
			{
				column.Capacity = 1;
			}

			for(Card card in card_holders)
			{
				card.reset();
			}
		}

		public static void check_ends()
		{

			let green_count = scope List<Card>();
			let red_count = scope List<Card>();
			let white_count = scope List<Card>();

			bool check_again = false;
			for(int i =0; i < 8; i++)
			{
				Card tip = columns[i].Back;
				if(tip.IsNumbercard())
				{
					NumberCard num_card = (NumberCard)tip;
					if(num_card.card_num == 1)
					{
						if(num_card.GetCardType() == .Bamboo)
						{
							List<Card> column = columns[11];
							num_card.Drop(column.Back);
						}

						if(num_card.GetCardType() == .Char)
						{
							num_card.Drop(columns[12].Back);
						}

						if(num_card.GetCardType() == .Coin)
						{
							num_card.Drop(columns[13].Back);
						}

						check_again = true;
					}
				}

				if(tip.GetCardType() == .Flower)
				{
					tip.Drop(columns[14].Back);
					check_again = true;
				}

				if(tip.card_type == .Green)
				{
					green_count.Add(tip);
				}

				if(tip.card_type == .Red)
				{
					red_count.Add(tip);
				}

				if(tip.card_type == .White)
				{
					white_count.Add(tip);
				}
			}

			if(green_count.Count == 4)
			{
				game_scene.dragon_green.SetMode(true);
			}

			if(red_count.Count == 4)
			{
				game_scene.dragon_red.SetMode(true);
			}

			if(white_count.Count == 4)
			{
				game_scene.dragon_white.SetMode(true);
			}

			if(check_again)
			{
				check_ends();
			}
		}
	}
}
