using System;
namespace Atma.Entities.Components
{
	public class CollisionComponent : Component
	{
		public bool isEnabled = true;
		private aabb2 _local_bounds;

		public this(bool active = false) : base(active)
		{

		}

		public aabb2 LocalBounds
		{
			get
			{
				return _local_bounds;
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

		public float Width => _local_bounds.Width;
		public float Height => _local_bounds.Height;
	}
}
