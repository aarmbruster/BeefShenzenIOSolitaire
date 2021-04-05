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

			dragon_green = AddEntity(	new SpecialButton(Core.Atlas["main/button_green_up"], 	float2(533, 53)));
			dragon_red = AddEntity(		new SpecialButton(Core.Atlas["main/button_red_up"], 	float2(533, 137)));
			dragon_white = AddEntity(	new SpecialButton(Core.Atlas["main/button_white_up"], 	float2(533, 219)));
			dragon_green.Depth = 1;
			dragon_red.Depth = 1;
			dragon_white.Depth = 1;
			
			card_manager.create_cards(this);

			int rand_time = DateTime.Now.Year + DateTime.Now.Day + DateTime.Now.Hour + DateTime.Now.Month + DateTime.Now.Second;

			card_manager.create_columns(this);

			Random rand = new Random(rand_time);
			card_manager.shuffle_cards(rand.Next(0, 60000));
			delete(rand);

			card_manager.place_cards(this);

			this.Camera.AddRenderer(new SceneRenderer(this));
		}

		public override void FixedUpdate()
		{
			base.FixedUpdate();
		}
	}
}
