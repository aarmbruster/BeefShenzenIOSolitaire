using Atma;
using System;
using BeefShenzenIOSolitaire.Entities;

namespace BeefShenzenIOSolitaire
{
	public class BeefShenzenIOSolitaire : Scene
	{
		public Player player;
		public Background background;

		public SpecialButton dragon_green;
		public SpecialButton dragon_red;
		public SpecialButton dragon_white;

		private CardManager card_manager = new CardManager()  ~ delete _;

		public this() : base(.ExactFit, Screen.Size)
		{
			Time.SetTargetFramerate(60);

			Core.Atlas.AddDirectory("main", "textures");
			Core.Atlas.AddDirectory("main", "textures/large_icons");
			Core.Atlas.AddDirectory("main", "textures/small_icons");
			Core.Atlas.Finalize();

			player = AddEntity(new Player(this));
			background = AddEntity(new Background());
			
			card_manager.create_cards(this);

			int rand_time = DateTime.Now.Year + DateTime.Now.Day + DateTime.Now.Hour + DateTime.Now.Month + DateTime.Now.Second;

			card_manager.create_columns(this);
			card_manager.setup_holders(this);
			Random rand = new Random(rand_time);
			card_manager.shuffle_cards(rand.Next(0, 60000));
			delete(rand);

			card_manager.place_cards(this);

			this.Camera.AddRenderer(new SceneRenderer(this));

			dragon_green = AddEntity(	new SpecialButton("green", 	float2(533, 53)));
			this.RegisterCollision(dragon_green.collision);
			dragon_red = AddEntity(		new SpecialButton("red", 	float2(533, 137)));
			this.RegisterCollision(dragon_red.collision);
			dragon_white = AddEntity(	new SpecialButton("white", 	float2(533, 219)));
			this.RegisterCollision(dragon_white.collision);
			dragon_green.Depth = 1;
			dragon_red.Depth = 1;
			dragon_white.Depth = 1;
		}

		public CardManager get_card_manager()
		{
			return card_manager;
		}
	}
}
