using System;
namespace Atma.Entities.Components
{
	public class CollisionComponent : Component
	{
		public bool isEnabled;
		private aabb2 _local_bounds;

		public this(bool active = false) : base(active)
		{

		}

		public aabb2 LocalBounds
		{
			get
			{
				if(isEnabled)
					return _local_bounds;
				return aabb2(0,0,0,0);
			}
			set
			{
				_local_bounds = value;
			}
		}
		public aabb2 WorldBounds
		{
			get
			{
				var bounds = LocalBounds;
				bounds.Center = Entity.WorldPosition;
				return bounds;
			}
		}
	}
}
