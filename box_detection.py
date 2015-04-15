from timer import timeStart, timeEnd

timeStart("import libs")
import numpy as np
from scipy import misc
from skimage.filters import threshold_otsu
from skimage.morphology import disk, opening
from skimage.segmentation import find_boundaries
from scipy.ndimage.measurements import label
timeEnd("import libs")

out_dir = "out"

def get_boundary(filename, debug = False):
  timeStart("read image")
  grayscale_image = misc.imread(filename, flatten = True)
  timeEnd("read image")
  
  timeStart("threshold image")
  threshold_value = threshold_otsu(grayscale_image)
  black_and_white_image = (grayscale_image > threshold_value)
  timeEnd("threshold image")

  timeStart("morphological open image")
  filter_element = disk(4) # 17 for full-size image
  opened_image = opening(black_and_white_image, filter_element)
  timeEnd("morphological open image")

  timeStart("invert image")
  opened_image = np.invert(opened_image)
  timeEnd("invert image")

  timeStart("segment image into connected regions")
  labeled_components, num_components = label(opened_image)
  timeEnd("segment image into connected regions")

  timeStart("calculate region areas")
  # Have to cast to np.intp with ndarray.astype because of a numpy bug
  # see: https://github.com/numpy/numpy/pull/4366
  areas = np.bincount(labeled_components.flatten().astype(np.intp))[1:]
  timeEnd("calculate region areas")

  timeStart("calculate region boundaries")
  image_boundaries = find_boundaries(labeled_components, connectivity=1, mode="inner", background=0)
  timeEnd("calculate region boundaries")

  timeStart("mask region of interest")
  largest_component_id = np.argmax(areas) + 1
  region_of_interest_mask = (labeled_components != largest_component_id)
  region_of_interest_boundary = np.copy(image_boundaries)
  region_of_interest_boundary[region_of_interest_mask] = 0
  timeEnd("mask region of interest")

  if debug:
    misc.imsave(out_dir+"/black_and_white_image.png", black_and_white_image)
    misc.imsave(out_dir+"/opened_image.png", opened_image)
    misc.imsave(out_dir+"/image_boundaries.png", image_boundaries)
    misc.imsave(out_dir+"/region_of_interest_boundary.png", region_of_interest_boundary)

  return region_of_interest_boundary


# def get_box_lines(boundary):

# for testing
get_boundary("in/dummy-seismo-small.png", debug=True)