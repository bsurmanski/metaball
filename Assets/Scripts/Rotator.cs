using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotator : MonoBehaviour {
	// simply rotate an object
	void FixedUpdate () {
		transform.Rotate (new Vector3 (1, 1, 0));
	}
}
