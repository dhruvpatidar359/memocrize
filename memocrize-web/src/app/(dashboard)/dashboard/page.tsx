"use client";

import { useEffect, useState } from "react";
import Image from "next/image";
import Balancer from "react-wrap-balancer";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Textarea } from "@/components/ui/textarea";
import { Button } from "@/components/ui/button";
import InformationDialog from "@/components/dialog/informationDialog";
import { Header } from "@/components/nav/header";
import { getCookie } from "cookies-next";

export default function DashboardPage(): JSX.Element {
  const [diseaseDetails, setDiseaseDetails] = useState("");
  const [foodDetails, setFoodDetails] = useState("");
  const [selectedImage, setSelectedImage] = useState<File | null>(null);
  const [recipeDetails, setRecipeDetails] = useState("");
  const [isFirstDialogOpen, setisFirstDialogOpen] = useState(false);
  const [isSecondDialogOpen, setisSecondDialogOpen] = useState(false);



  useEffect(() => {

    console.log(getCookie("googleAccessToken"));

  }, [])
  

  const handleImageUpload = (event: React.ChangeEvent<HTMLInputElement>) => {
    
    if (event.target.files && event.target.files[0]) {
      setSelectedImage(event.target.files[0]);
    }
  };

  const handleKnowClick = () => {
    if (!diseaseDetails || !foodDetails) {
      alert("Please enter both disease and food details.");
    } else {
      // Handle the logic for knowing
      alert("Details submitted successfully!");
    }
  };

  const handleRecipeClick = () => {
    if (!recipeDetails) {
      alert("Please enter details about the type of food you want.");
    } else {
      // Handle the logic for getting recipes
      alert("Recipe details submitted successfully!");
    }
  };

  return (
    <div>
      <Header></Header>
      <div className="space-y-4 md:mt-20 md:space-y-6 sm:p-10 p-2">
        <Card
          id="dashboard-1"
          className="h-fit bg-gradient-to-br from-pink-600/10 to-purple-400/10 transition-all duration-1000 ease-out md:hover:-translate-y-3"
        >
          <CardHeader>
            <CardDescription className="py-2 text-base font-medium tracking-wide text-muted-foreground">
              Enter the Details of Disease
            </CardDescription>
            <CardTitle className="font-urbanist text-3xl font-black tracking-wide">
              <Balancer>
                Please enter the exact information <br className="hidden md:inline-block" />
              </Balancer>
            </CardTitle>
          </CardHeader>
          <CardContent className="space-y-6">
            <Textarea
              value={diseaseDetails}
              onChange={(e) => setDiseaseDetails(e.target.value)}
              placeholder="I am having common cold and having headache"
              className="text-base font-medium border-2  resize-none"
            />
          </CardContent>
        </Card>

        <div className="flex sm:flex-row flex-col gap-4 w-full">
          <Card
            id="dashboard-2"
            className="h-fit sm:w-1/2 bg-gradient-to-br from-pink-600/10 to-purple-400/10 transition-all duration-1000 ease-out md:hover:-translate-y-3"
          >
            <CardHeader>
              <CardDescription className="py-2 text-base font-medium tracking-wide text-muted-foreground">
                What food you are going to eat
              </CardDescription>
              <CardTitle className="font-urbanist text-3xl font-black tracking-wide">
                <Balancer>Tell about your food or upload image</Balancer>
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-2 sm:p-6 ">
              <div className="flex flex-col  rounded-lg h-48  ">
                <div className="flex flex-row justify-end p-2">
                  <label htmlFor="image-upload" className="bg-white rounded-lg p-1 cursor-pointer">
                    <Image src={"/image.svg"} alt="upload-image" height={30} width={30} />
                  </label>
                  <input
                    id="image-upload"
                    type="file"
                    className="hidden"
                    onChange={handleImageUpload}
                  />
                </div>
                <Textarea
                  value={foodDetails}
                  onChange={(e) => setFoodDetails(e.target.value)}
                  className=" flex-1 text-white border-2   resize-none font-medium "
                  style={{ boxShadow: 'inset 0 2px 6px rgba(0, 0, 0, 0.3)' }}
                  placeholder="Enter the Details of your food"
                />
                <div className="flex flex-row justify-end">
<InformationDialog></InformationDialog>
</div>
              </div>


            

              <div className="flex flex-row w-full justify-center">
                <Button className="sm:w-1/2" onClick={handleKnowClick}>
                  Know!
                </Button>
              </div>
            </CardContent>
            
          </Card>

          <Card
            id="dashboard-3"
            className="h-fit sm:w-1/2 bg-gradient-to-br from-pink-600/10 to-purple-400/10 transition-all duration-1000 ease-out md:hover:-translate-y-3"
          >
            <CardHeader>
              <CardDescription className="py-2 text-base font-medium tracking-wide text-muted-foreground">
                want any suggestions on the food
              </CardDescription>
              <CardTitle className="font-urbanist text-3xl font-black tracking-wide">
                <Balancer>Want tasty recipes for your good health?</Balancer>
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-2 p-6">

            <div className="flex flex-col rounded-lg h-48  ">
            
                <Textarea
                  value={recipeDetails}
                  onChange={(e) => setRecipeDetails(e.target.value)}
                  className=" flex-1 text-white border-2  resize-none font-medium "
                  style={{ boxShadow: 'inset 0 2px 6px rgba(0, 0, 0, 0.3)' }}
                  placeholder="Any suggestions , for the recommendation"
                />
                  <div className="flex flex-row justify-end">
<InformationDialog></InformationDialog>
</div>
              </div>

          
         
              <div className="flex flex-row w-full justify-center">
                <Button className="sm:w-1/2" onClick={handleRecipeClick}>
                  Know!
                </Button>
              </div>


         
             
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}
