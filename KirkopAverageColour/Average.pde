/*
Author: WILBERT TABONE 
AVERAGE COLOUR FINDING ALGORITHM
*/

//the initial colour channels
float red,green,blue;


//the returned value from averageXYZ() will be assigned to this var of type ColorXYZ.
ColorXYZ colorxyz;

//the returned colour from sRGBaverage() will be assigned to this colour vars.
color srgb;


////////////////////////////////////////////////////////////////////////


public ColorXYZ averageXYZ(PImage img)
{
  img.loadPixels();
  float total_x = 0;
  float total_y = 0;
  float total_z = 0;
  
  for(int j=0; j<img.pixels.length; j++)
  {
    //assign channel calues of that pixel to the float var
    red=red(img.pixels[j]);
    green=green(img.pixels[j]);
    blue=blue(img.pixels[j]);

   // normalize the channel values (red,green,blue)
    float rLinear=  (float)red/255.0;
    float gLinear = (float)green/255.0;
    float bLinear = (float)blue/255.0;

   //convert to linear Form 
    float r = linearize(rLinear);
    float g = linearize(gLinear);
    float b = linearize(bLinear);
    
    
    //convert to CIE XYZ Form 
    float x_XYZ=(r*0.4124 + g*0.3576 + b*0.1805);
    float y_XYZ=(r*0.2126 + g*0.7152 + b*0.0722);
    float z_XYZ=(r*0.0193 + g*0.1192 + b*0.9505);

    //add all the corrdinate values of the image seperately
    
     total_x+= x_XYZ;   
     total_y+= y_XYZ;   
     total_z+= z_XYZ;   
  }
                                                                                                                                        
   //calculate the average of each colour channel 
   float average_x= (total_x/img.pixels.length)*100;
   float average_y= (total_y/img.pixels.length)*100;
   float average_z= (total_z/img.pixels.length)*100;
   
   //assign values to the colorxyz object 
   colorxyz = new ColorXYZ(average_x, average_y, average_z);
   return colorxyz;
} 

//////////////////////////////////////////////////////////////////////// 

public color sRGBaverage(ColorXYZ colorxyz)
{
    //normalize the coordinate values
    float normX=  (float)colorxyz.x/100.0;  
    float normY = (float)colorxyz.y/100.0;
    float normZ = (float)colorxyz.z/100.0;
   
    //convert from CIE XYZ to sRGB form
    float  redc =   (normX*3.2410  +  normY*-1.5374 + normZ*-0.4986);  
    float  greenc = (normX*-0.9692 +  normY*1.8760  + normZ*0.0416);
    float  bluec =  (normX*0.0556  +  normY*-0.2040 + normZ*1.0570);
  
     
    //nonLinearizing the values in order to display in sRGB form.
    float rNonLinear = nonLinearize(redc);
    float gNonLinear = nonLinearize(greenc);
    float bNonLinear = nonLinearize(bluec);

   
   // unnormalize the channel values (red,green,blue)
    float r_UnN = ((float)rNonLinear*255.0);  
    float g_UnN = ((float)gNonLinear*255.0);
    float b_UnN = ((float)bNonLinear*255.0);
    
    //create colour with red, green and blue values
    color sRGBaverage = color(r_UnN, g_UnN, b_UnN);
    
    return sRGBaverage;
}
   
////////////////////////////////////////////////////////////////////////   

float linearize(float nonLinearValue)
{
    //Linearizing the colour values 
    float linearVal = (nonLinearValue < 0.04045)?  (nonLinearValue/12.92): pow((nonLinearValue + 0.055)/(1.055), 2.4);  
    return linearVal;
}

////////////////////////////////////////////////////////////////////////

float nonLinearize(float linearValue)
{
  //NonLinearising the colour values
    float nonLinearVal = (linearValue < 0.00304)? (12.92*linearValue) : 1.055*pow(linearValue,1/2.4) - 0.055;  
    return nonLinearVal;
}
