/*
Author: WILBERT TABONE 
AVERAGE COLOUR FINDING EXPERIMENT
*/

 
//boolean that states if in the main program or not (if image has been processed)
boolean processed;

//canvas dimensions
int SZ = 800;

////////////////////////////////////////////////////////////////////////

void setup()
{
  
  //set screen parameters
  size(800,800);
  
  ArrayList<Integer> averageColorList = new ArrayList<Integer>();
  
  //load all images one by one 
  //ArrayList<PImage> listOfImages = new ArrayList<PImage>();
  for(int i=0; i<99; i++){
    PImage currImg = loadImage("img"+i+".JPG");
    println("Now Loaded Image Num "+i);
    //calculate average colour
    color avgColourSRGB = averageOfImage(currImg);
    //add average colour to arrayList
    averageColorList.add(avgColourSRGB);
    println("Now Added To Colour List Image Num "+i);
  }
 
  //draw the mosaic
  createMosaic(averageColorList);
  
  //save image to file
  save("averageMosaic.png");
  println("SAVED MOSAIC");
  
  
  processed = true; //mosaic displayed

  noStroke();
    
}

////////////////////////////////////////////////////////////////////////

void draw()
{
}

////////////////////////////////////////////////////////////////////////

//handles the buttons events
void mouseClicked()  
{
  //if mosaic is displayed
  if(processed)
  {
   PImage mosaicImg = loadImage("averageMosaic.png");
   int overallAverageColor = averageOfImage(mosaicImg);
   noStroke();
   fill(overallAverageColor);
   rect(0,0,SZ,SZ);
  }

}

////////////////////////////////////////////////////////////////////////
void mouseMoved()
{
 if((mouseY> 0) && (mouseY < SZ))
 {
   //handles the color inspector (sRGB: xxx,xxx,xxx)
    color posColor = get(mouseX,mouseY);
    println("sRGB:  "+(int)red(posColor)+"   "+(int)green(posColor)+"   "+(int)blue(posColor));
 }
}

////////////////////////////////////////////////////////////////////////

//handles tiling and averaging method calls of the image.
void createMosaic(ArrayList<Integer> averageColorList)  
{
  //Calculate Number of Tiles and Dimensions
  int numberOfImages = averageColorList.size();
  int roundedGridNum = ceil(sqrt(numberOfImages)); //number of grids (nxn), where n is this variable
  int ts = SZ/roundedGridNum; //tileSize
  int averageColourNum = 0;
    
  //tile the canvas and fill with average colour
  for(int i = 0; i<SZ; i+=ts)
  {
    for(int j=0; j<SZ; j+=ts)
    {
      if(averageColourNum < numberOfImages)
      {
        //draw a rectange at location (size: 'ts' by 'ts')
        noStroke();
        fill(averageColorList.get(averageColourNum));
        rect(i,j,ts,ts);  //'ts' is 100 by default but value may be changed in setup();
        averageColourNum++;
      }
      else break;
      }
  }
}

////////////////////////////////////////////////////////////////////////

int averageOfImage(PImage currImg)
{

  ColorXYZ cieXYZ;
  color average_o;
  
  //calculate the average of the entire image
  cieXYZ =  averageXYZ(currImg);
  average_o = sRGBaverage(cieXYZ);

 return average_o;
}
