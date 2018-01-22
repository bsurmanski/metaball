using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// A MetaballCast is kind of like a window into the Metaball universe.
// It is expected this object has the MetaballCast material attached.
// This material dynamically computes a view of the the metaballs in the 'metaball' list here.
public class MetaballCast : MonoBehaviour
{
	// Expects this to be populated
	public List<Metaball> metaballs;

	struct GPUMetaball
	{
		Vector3 position;
		float radius;
	}
	
	// Update is called once per frame
	void Update ()
	{
		Material mat = this.GetComponent<Renderer> ().material;
		Vector4[] mb_vecs = new Vector4[64];
		int i = 0;
		foreach (Metaball b in metaballs) {
				mb_vecs [i] = new Vector4 (b.transform.position.x, 
					b.transform.position.y,
					b.transform.position.z, 
					b.radius);
			i++;
		}
		for (; i < 64; i++) {
			mb_vecs [i] = Vector4.zero; // reset radius of if unused;
		}
		mat.SetVectorArray ("metaballs", mb_vecs);

	}
}
